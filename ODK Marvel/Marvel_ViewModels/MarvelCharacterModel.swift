//
//  MarvelCharacterModel.swift
//  ODK Marvel
//
//  Created by wyndot on 1/22/22.
//

import UIKit
import Combine

final class MarvelCharacterModel: Identifiable, ObservableObject {
    var id: Int
    var name: String
    var description: String
    var imagePath: MVPath
    var imageVariant: MarvelAPI.ImageVariant {
        didSet {
            loadThumbnail()
        }
    }
    @Published var image: UIImage = UIImage(named: "Not-Available")!
    
    private var cancellable: AnyCancellable?
    
    init(id: Int, name: String, description: String, imagePath: MVPath, imageVariant: MarvelAPI.ImageVariant) {
        self.id = id
        self.name = name
        self.description = description
        self.imagePath = imagePath
        self.imageVariant = imageVariant
        loadThumbnail()
    }
    
    convenience init(character: MVCharacter, imageVariant: MarvelAPI.ImageVariant = .squareSmall) {
        self.init(id: character.id ?? 0, name: character.name ?? "", description: character.description ?? "", imagePath: character.thumbnail ?? MVPath(path: "", extension: ""), imageVariant: imageVariant)
    }
    
    convenience init(model: MarvelCharacterModel, imageVariant: MarvelAPI.ImageVariant = .fullSize) {
        self.init(id: model.id, name: model.name, description: model.description, imagePath: model.imagePath, imageVariant: imageVariant)
    }
    
    private func loadThumbnail() {
        guard let path = self.imagePath.path,  let ext = self.imagePath.extension, !path.isEmpty, !ext.isEmpty else {
            return
        }
        cancellable =  MarvelAPI.getImage(path: path, variant: imageVariant, ext:ext)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: {[unowned self] image in
                self.image = image
            }
    }
}
