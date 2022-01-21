//
//  MVDataContainer.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation

struct MVDataContainer<T: Codable>: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [T]?
}
