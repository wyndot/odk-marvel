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
                            MarvelDetailView(character: item)
                                .navigationTitle(item.name)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            MarvelListRowView(character: item)
                        }
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Button {
                            marvelList.loadMore()
                        } label: {
                            Text("Load more...").font(.headline).foregroundColor(.accentColor).frame(maxWidth: .infinity)
                        }
                    }
                }
            .navigationTitle("Marvel Characters")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(marvelList.$characters) { characters in
            if (list.count == characters.count) {
                // update the list
                for (idx, item) in list.enumerated() {
                    item.update(character: characters[idx])
                }
            }
            else {
                // recreate the list
                list = characters.map {MarvelCharacterModel(character: $0)}
            }
            
        }
        
    }
}

struct MarvelListView_Previews: PreviewProvider {
    static var previews: some View {
        MarvelListView().environment(\.characterList, MarvelCharacterList())
    }
}
