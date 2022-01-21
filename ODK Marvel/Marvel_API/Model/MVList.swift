//
//  MVList.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation

struct MVList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [MVURI]?
}
