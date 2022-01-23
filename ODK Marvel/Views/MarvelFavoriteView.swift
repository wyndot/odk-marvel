//
//  MarvelFavoriteView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/22/22.
//

import SwiftUI

struct MarvelFavoriteView: View {
    @Environment(\.characterList) var marvelList
    @State private var list: [MarvelCharacterModel] = []
    
    var body: some View {
        NavigationView {
            List {
                    ForEach(list) { item in
                        NavigationLink {
                            MarvelDetailView(character: item)
                                .navigationTitle(item.name)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            MarvelListRowView(character: item)
                        }
                    }
                }
            .navigationTitle("Favorite Characters")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(marvelList.$favorites) { characters in
            self.list = characters.map { MarvelCharacterModel(character: $0)}
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelFavoriteView()
    }
}
