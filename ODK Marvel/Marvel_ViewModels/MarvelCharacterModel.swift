//
//  MarvelCharacterModel.swift
//  ODK Marvel
//
//  Created by wyndot on 1/22/22.
//

import UIKit
import Combine

final class MarvelCharacterModel: Identifiable, ObservableObject {
    var id: Int {
        return characterId + (favorite ? 100000000 : 0)
    }
    var characterId: Int
    var name: String
    var description: String
    
    var imagePath: MVPath
    var imageVariant: MarvelAPI.ImageVariant
    
    @Published var image: UIImage?
    @Published var fullImage: UIImage?
    @Published var favorite: Bool
    
    private var cancellable: AnyCancellable?
    
    init(characterId: Int, name: String, description: String, favorite: Bool, imagePath: MVPath, imageVariant: MarvelAPI.ImageVariant) {
        self.characterId = characterId
        self.name = name
        self.description = description
        self.favorite = favorite
        self.imagePath = imagePath
        self.imageVariant = imageVariant
    }
    
    convenience init(character: MVCharacter, imageVariant: MarvelAPI.ImageVariant = .squareSmall) {
        self.init(characterId: character.id ?? 0, name: character.name ?? "", description: character.description ?? "", favorite: character.favorite ?? false,  imagePath: character.thumbnail ?? MVPath(path: "", extension: ""), imageVariant: imageVariant)
    }
    
    convenience init(model: MarvelCharacterModel, imageVariant: MarvelAPI.ImageVariant = .squareSmall) {
        self.init(characterId: model.characterId, name: model.name, description: model.description, favorite: model.favorite, imagePath: model.imagePath, imageVariant: imageVariant)
    }
    
    func update(character: MVCharacter) {
        self.characterId = character.id ?? 0
        self.name = character.name ?? ""
        self.description = character.description ?? ""
        self.imagePath = character.thumbnail ?? MVPath(path: "", extension: "")
        self.favorite = character.favorite ?? false
    }
    
    func loadFullImage() {
        guard let path = self.imagePath.path,  let ext = self.imagePath.extension, !path.isEmpty, !ext.isEmpty else {
            return
        }
        cancellable =  MarvelAPI.getImage(path: path, variant: .fullSize, ext:ext)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: {[unowned self] image in
                self.fullImage = image
            }
    }
    
    func unloadFullImage() {
        self.fullImage = nil
    }
    
    func loadThumbnail() {
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
    
    func unloadThumbnail() {
        self.image = nil 
    }
}
