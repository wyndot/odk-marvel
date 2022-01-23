//
//  MarvelListView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI

struct MarvelListView: View {
    @Environment(\.characterList) var marvelList
    @State var list: [MarvelCharacterModel] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(list) { item in
                    NavigationLink {
                        MarvelDetailView(character: MarvelCharacterModel(model: item, imageVariant: .fullSize))
                    } label: {
                        MarvelListRowView(character: item)
                    }
                }
            }
        }
        .onReceive(marvelList.$characters) { characters in
            self.list = characters.map { MarvelCharacterModel(character: $0)}
        }
    }
}

struct MarvelListView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelListView()
    }
}
