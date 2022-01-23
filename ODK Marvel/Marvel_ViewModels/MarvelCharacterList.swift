//
//  MarvelCharacterList.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation
import Combine
import SwiftUI

final class MarvelCharacterList: ObservableObject {
    @Published var limit: Int = 10
    @Published var offset: Int = 0
    @Published var characters: [MVCharacter] = []
    @Published var favorites: [MVCharacter] = []
    private var characterIDs: Set<Int> = []
    private var favoritesIDs: Set<Int> = []
    
    private var loadCancellable: AnyCancellable?
    
    init() {
        try? loadFavorites()
        self.load()
    }
    
    ///
    /// Load Characters start from offset and with the limit
    ///
    ///  - parameters:
    ///     - offset: the offset parameter for the Marvel API
    ///     - limit: the limit parameter for the Marvel API
    ///  - NOTE:
    ///  The loaded characters will be published via characters property
    ///
    func load(offset: Int = 0, limit: Int = 10) {
        loadCancellable?.cancel()
        
        self.limit = limit
        self.offset = offset
        loadCancellable = MarvelAPI.getCharacters(offset: offset, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink {  [unowned self] completion  in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.characters = []
                }
            } receiveValue: { [unowned self] result in
                if let characters = result.data?.results {
                    append(characters: characters)
                }
            }
    }
    
    ///
    /// Load another range of limit start from the current offset
    ///
    func loadMore() {
        load(offset: self.offset + self.limit)
    }
    
    ///
    /// Add character with id to the favorites list
    ///
    /// - parameters:
    ///  - id: the character id
    ///
    func addFavorite(id: Int, save: Bool = true) {
        guard characterIDs.contains(id) else {
            return
        }
        guard !favoritesIDs.contains(id) else {
            return
        }
        
        var newCharacters = characters
        guard let idx = newCharacters.firstIndex(where: {$0.id == id}) else {
            fatalError("Character List corrupted")
        }
        var character = newCharacters[idx]
        character.favorite = true
        favorites.append(character)
        favoritesIDs.insert(id)
        newCharacters.remove(at: idx)
        newCharacters.insert(character, at: idx)
        characters = newCharacters
        
        if save {
            do {
                try saveFavorites()
            } catch let err {
                print(err)
            }
        }
    }
    
    ///
    /// Remove the character with id from the favorites list
    ///
    /// - parameters:
    ///  - id: the character id
    ///
    func removeFavorite(id: Int, save: Bool = true) {
        guard favoritesIDs.contains(id) else {
            return
        }
        favoritesIDs.remove(id)
        guard let idx = favorites.firstIndex(where: {$0.id == id}) else {
            fatalError("Favorites List corupted")
        }
        favorites.remove(at: idx)
        
        var newCharacters = characters
        guard let idx = newCharacters.firstIndex(where: {$0.id == id}) else {
            fatalError("Character List corrupted")
        }
        var character = newCharacters[idx]
        character.favorite = false
        newCharacters.remove(at: idx)
        newCharacters.insert(character, at: idx)
        characters = newCharacters
        
        if save {
            do {
                try saveFavorites()
            } catch let err {
                print(err)
            }
        }
    }
    
    ///
    /// URL to where the favorites saved
    ///
    private func favoritesFileURL() -> URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("favorites.json")
    }
    
    ///
    /// Save the favorites
    ///
    private func saveFavorites() throws {
        let data = try JSONEncoder().encode(favorites)
        try data.write(to: favoritesFileURL())
    }
    
    ///
    /// Load the saved favorites
    ///
    private func loadFavorites() throws {
        let data = try Data(contentsOf: favoritesFileURL())
        let list = try JSONDecoder().decode([MVCharacter].self, from: data)
        append(characters: list)
        for item in list {
            guard let id = item.id else {
                continue
            }
            addFavorite(id: id, save: false)
        }
    }
     
    ///
    /// append the characters and make sure the characters in the list are unique
    ///
    /// - parameters:
    ///     - characters: the appending characters
    ///
    private func append(characters: [MVCharacter]) {
        var ids: Set<Int> = self.characterIDs
        let new: [MVCharacter] = characters.compactMap { character in
            guard let id = character.id, !ids.contains(id) else {
                return nil
            }
            ids.insert(id)
            return character
        }
        self.characterIDs = ids
        self.characters += new
    }
}

extension EnvironmentValues {
    private struct MarvelCharacterListKey: EnvironmentKey {
        static let defaultValue = MarvelCharacterList()
    }
    
    var characterList: MarvelCharacterList {
        get { self[MarvelCharacterListKey.self] }
        set { self[MarvelCharacterListKey.self] = newValue }
    }
}
