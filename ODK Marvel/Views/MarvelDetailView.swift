//
//  MarvelDetailView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI
import CryptoKit

struct MarvelDetailView: View {
    @State var character: MarvelCharacterModel
    @State var image: UIImage = UIImage(named: "Not-Available")!
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(uiImage:character.image).resizable().scaledToFit()
            Text(character.name).font(.largeTitle).foregroundColor(.accentColor)
            Text(character.description).font(.caption).foregroundColor(.accentColor)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .onReceive(character.$image) { res in
            image = res
        }
    }
}

struct MarvelDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelDetailView(character: MarvelCharacterModel(id: 0, name: "", description: "", imagePath: MVPath(path: "", extension: ""), imageVariant: .fullSize))
    }
}
