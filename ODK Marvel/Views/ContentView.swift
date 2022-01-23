//
//  ContentView.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        TabView{
            MarvelListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Marvel Characters")
                }
            
            MarvelFavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorite Characters")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.characterList, MarvelCharacterList())
    }
}
