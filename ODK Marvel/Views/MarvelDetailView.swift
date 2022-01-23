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
    @State var character: MarvelCharacterModel
    @State var image: UIImage
    @State var favorite: Bool
    
    init(character: MarvelCharacterModel) {
        self.character = character
        self.image = character.image ?? UIImage(named: "Not-Available")!
        self.favorite = character.favorite
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(uiImage:image).resizable().scaledToFit()
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
            guard let img = res else {
                return
            }
            image = img
        }
        .onReceive(character.$fullImage, perform: { res in
            guard let img = res else {
                return
            }
            image = img
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
}

struct MarvelDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelDetailView(character: MarvelCharacterModel(characterId: 0, name: "3-D Man", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", favorite: false, imagePath: MVPath(path: "", extension: ""), imageVariant: .fullSize))
    }
}
