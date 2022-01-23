//
//  ODK_MarvelApp.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import SwiftUI

@main
struct ODK_MarvelApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.characterList, MarvelCharacterList())
        }
    }
}
