//
//  MarvelListRowView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/22/22.
//

import SwiftUI

struct MarvelListRowView: View {
    @State private var character: MarvelCharacterModel
    @State private var image: UIImage
    @State private var favorite: Bool 
    
    init(character: MarvelCharacterModel) {
        self.character = character
        self.image = character.image ?? UIImage(named: "Not-Available")!
        self.favorite = character.favorite
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(uiImage: image).resizable().scaledToFit().frame(width: 40, height: 40, alignment: .center)
            VStack(alignment: .leading, spacing: 0) {
                Text(character.name).font(.subheadline)
                Text(character.description).font(.caption).frame(maxHeight: 40)
            }
            Spacer()
            Image(systemName: favorite ? "star.fill" : "star")
        }
        .onReceive(character.$image) { res in
            guard let img = res else {
                return
            }
            image = img
        }
        .onReceive(character.$favorite, perform: { res in
            favorite = res
        })
        .onAppear {
            character.loadThumbnail()
        }
        .onDisappear {
            character.unloadThumbnail()
        }
    }
}

struct MarvelListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelListRowView(character: MarvelCharacterModel(characterId: 0, name: "3-D Man", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ", favorite: false, imagePath: MVPath(path: "", extension: ""), imageVariant: .fullSize)).frame(height: 40)
    }
}
