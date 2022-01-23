//
//  MarvelDetailView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI
import CryptoKit

struct MarvelDetailView: View {
    @Environment(\.characterList) var marvelList
    @State private var character: MarvelCharacterModel
    @State private var image: UIImage
    @State private var favorite: Bool
    @State private var imageOffset: CGSize = CGSize(width: 0, height: -20)
    @State private var imageScale: CGSize = CGSize(width: 0, height: 0)
    @State private var imageAngle: CGFloat = 1000
    
    init(character: MarvelCharacterModel) {
        self.character = character
        self.image = character.image ?? UIImage(named: "Not-Available")!
        self.favorite = character.favorite
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(uiImage:image).resizable().scaledToFit()
                .drop(offset: imageOffset)
                .expand(scale: imageScale)
                .rotate(angle: imageAngle)
            Text(character.name).font(.largeTitle).foregroundColor(.accentColor)
            Text(character.description).font(.caption).foregroundColor(.accentColor)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    favorite.toggle()
                    if favorite {
                        marvelList.addFavorite(id: character.characterId)
                    }
                    else {
                        marvelList.removeFavorite(id: character.characterId)
                    }
                    
                } label: {
                    Image(systemName: favorite ? "star.fill" : "star")
                }

            }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .onReceive(character.$image) { res in
//            guard let img = res else {
//                return
//            }
//            image = img
        }
        .onReceive(character.$fullImage, perform: { res in
            guard let img = res else {
                return
            }
            image = img
            
            randomAnimation()
        })
        .onReceive(character.$favorite, perform: { res in
            favorite = res
        })
        .onAppear {
            character.loadFullImage()
        }
        .onDisappear {
            character.unloadFullImage()
        }
    }
    
    ///
    /// randomize the animation of the image
    /// 
    
    func randomAnimation() {
        switch Int.random(in: 0...4) {
        case 0:
            imageOffset = CGSize(width: 0, height: -50)
            imageScale = CGSize(width: 1, height: 1)
            imageAngle = 0
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 50, damping: 1, initialVelocity: 5)) {
                imageOffset = CGSize()
            }
            
        case 1:
            imageOffset = CGSize(width: -50, height: 0)
            imageScale = CGSize(width: 1, height: 1)
            imageAngle = 0
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 50, damping: 1, initialVelocity: 5)) {
                imageOffset = CGSize()
            }
            
        case 2:
            imageOffset = CGSize(width: 0, height: 0)
            imageScale = CGSize(width: 0, height: 0)
            imageAngle = 1000
            withAnimation(Animation.easeOut(duration: 1)) {
                imageScale = CGSize(width: 1, height: 1)
                imageAngle = 0
            }
        case 3:
            imageOffset = CGSize(width: 0, height: 0)
            imageScale = CGSize(width: 0, height: 1)
            imageAngle = 0
            withAnimation(Animation.easeOut(duration: 1)) {
                imageScale = CGSize(width: 1, height: 1)
                imageAngle = 0
            }
        case 4:
            imageOffset = CGSize(width: 0, height: 0)
            imageScale = CGSize(width: 1, height: 0)
            imageAngle = 0
            withAnimation(Animation.easeOut(duration: 1)) {
                imageScale = CGSize(width: 1, height: 1)
                imageAngle = 0
            }
        default:
            break
        }
    }
}

struct MarvelDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelDetailView(character: MarvelCharacterModel(characterId: 0, name: "3-D Man", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", favorite: false, imagePath: MVPath(path: "", extension: ""), imageVariant: .fullSize))
    }
}
