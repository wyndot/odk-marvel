//
//  MarvelDetailView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI
import CryptoKit

struct MarvelDetailView: View {
    @State var character: MarvelCharacterDetailItem
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(uiImage: character.thumbnail).resizable().scaledToFit()
            Text(character.name).font(.largeTitle).foregroundColor(.accentColor)
            Text(character.description).font(.caption).foregroundColor(.accentColor)
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
}

struct MarvelDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelDetailView(character: MarvelCharacterDetailItem(id: 0, name: "", description: "", thumbnail: "", thumbnailExt: ""))
    }
}
