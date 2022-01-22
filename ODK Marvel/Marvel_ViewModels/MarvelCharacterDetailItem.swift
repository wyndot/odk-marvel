//
//  MarvelCharacterDetailItem.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation
import UIKit
import Combine

final class MarvelCharacterDetailItem: ObservableObject {
    var id: Int
    var name: String
    var description: String
    var thumbnailPath: String
    var thumbnailExt: String
    @Published var thumbnail: UIImage = UIImage(named: "Not-Available")!
    
    private var cancellable: AnyCancellable?
    
    init(id: Int, name: String, description: String, thumbnail: String, thumbnailExt: String) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailPath = thumbnail
        self.thumbnailExt = thumbnailExt
        loadThumbnail()
    }
    
    init(character: MVCharacter) {
        self.id = character.id ?? 0
        self.name = character.name ?? ""
        self.description = character.description ?? ""
        self.thumbnailPath = character.thumbnail?.path ?? ""
        self.thumbnailExt = character.thumbnail?.extension ?? ""
        loadThumbnail()
    }
    
    private func loadThumbnail() {
        guard !self.thumbnailPath.isEmpty && !self.thumbnailExt.isEmpty else {
            return
        }
        cancellable =  MarvelAPI.getImage(path: self.thumbnailPath, variant: .fullSize, ext: self.thumbnailExt)
            .sink { _ in
                
            } receiveValue: {[unowned self] image in
                self.thumbnail = image
            }

    }
}
