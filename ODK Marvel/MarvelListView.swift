//
//  MarvelListView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI

struct MarvelListView: View {
    @Environment(\.characterList) var marvelList
    @State var list: [MarvelCharacterListItem] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(list) { item in
                    NavigationLink {
                        // MarvelCharacterListItem is built from marvelList, so filter marvelList with the name of the character will always return the character
                        MarvelDetailView(character: MarvelCharacterDetailItem(character: marvelList.characters.filter{ $0.name == item.name }.first!)
                        )
                    } label: {
                        Text(item.name)
                    }
                }
            }
        }
        .onReceive(marvelList.$characters) { characters in
            self.list = characters.map { MarvelCharacterListItem(id: $0.id ?? 0, name: $0.name ?? "", description: $0.description ?? "")}
        }
    }
}

struct MarvelListView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelListView()
    }
}
