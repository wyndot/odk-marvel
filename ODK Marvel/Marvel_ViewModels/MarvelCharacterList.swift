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
    private var characterIDs: Set<Int> = []
    
    private var loadCancellable: AnyCancellable?
    
    init() {
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
