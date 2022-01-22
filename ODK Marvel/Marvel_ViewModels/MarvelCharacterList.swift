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
    
    private var loadCancellable: AnyCancellable?
    
    init() {
        self.load()
    }
    
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
                    self.characters = characters
                }
                else {
                    self.characters = []
                }
            }
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
