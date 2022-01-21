//
//  MVDataWrapper.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation

struct MVDataWrapper<T: Codable>: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: T?
    let etag: String?
}
