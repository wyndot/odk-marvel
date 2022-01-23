//
//  MVCharacter.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation

struct MVCharacter: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let resourceURI: String?
    let urls: [MVURL]?
    let thumbnail: MVPath?
    let comics: MVList?
    let stories: MVList?
    let events: MVList?
    let series: MVList?
    
    // state variable in the app 
    var favorite: Bool?
    
}
