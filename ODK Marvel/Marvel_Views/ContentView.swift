//
//  ContentView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.characterList) var marvelList
    @State private var favoritesCount: Int = 0

    var body: some View {
        TabView{
            MarvelListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Marvel Characters")
                }
            
            MarvelFavoriteView()
                .badge(favoritesCount)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorite Characters")
                }
        }
        .onReceive(marvelList.$favorites) { characters in
            self.favoritesCount = characters.count
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.characterList, MarvelCharacterList())
    }
}
