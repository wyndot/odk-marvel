//
//  MarvelAPI.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation
import Combine
import CryptoKit

struct MarvelAPI {
    
    enum MVAPIError: Error {
        case generic(message: String)
        case statusCodeError(code: Int, message: String)
    }
    
    ///
    /// Marvel API Public Key, must be set in the Xcode enviroment variables
    ///
    static var publicKey: String {
        ProcessInfo.processInfo.environment["marvel_public_key"]!
    }
    
    ///
    /// Marvel API Private Key, MUST be set in the Xcode environment variables
    ///
    static var privateKey: String {
        ProcessInfo.processInfo.environment["marvel_private_key"]!
    }
    
    ///
    /// Marvel API base URL string  a valid Marvel URL string must be set in the Xcode environment variable or the defualt will be used.
    ///
    static var baseURLString: String {
        ProcessInfo.processInfo.environment["marvel_base_url"] ?? "https://gateway.marvel.com:443/"
    }
    
    ///
    /// Make the Marvel API Get Request with the specified endpoint
    ///
    /// - parameters:
    ///     - endpoint: the endpoint of the marvel api request, example : /v1/public/characters
    ///     - params: query parameters to the endpoint
    /// - returns: URLRequest? the get request, return nil if the endpoint is invalid endpoint string
    ///
    /// - NOTE: params will not cause the func return nil, if the configuration and endpoint string are correct,  func should always return the request
    ///
    static func get(endpoint: String, params: [String: String] = [:]) -> URLRequest? {
        URL(string: endpoint.marvelFullEndPoint + params.queryString)
            .map{
                URLRequest(url: $0, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
            }
    }
    
    ///
    /// Get Characters API Call
    ///
    /// - parameters:
    ///     - limit: limit of characters return
    ///     - offset: offset of the returning characters
    ///
    /// - returns: A Publisher with MVCharacters content type
    ///
    static func getCharacters(limit: Int = 50, offset: Int = 0) -> AnyPublisher<MVDataWrapper<MVDataContainer<MVCharacter>>, Error> {
        guard let req = get(endpoint: "/v1/public/characters", params: ["orderBy": "name", "limit": "\(limit)", "offset": "\(offset)"]) else {
            fatalError("Failed to build the marvel get characters api request")
        }
        return URLSession.shared.dataTaskPublisher(for: req).tryMap { data, response -> Data in
            guard let res = response as? HTTPURLResponse else {
                throw MarvelAPI.MVAPIError.generic(message: "Get Characters API Response is not HTTPURLResponse")
            }
            if  res.statusCode != 200 {
                throw MarvelAPI.MVAPIError.statusCodeError(code: res.statusCode, message: "Get Characters API Response Status code is not 200")
            }
            
            return data
        }
        .decode(type: MVDataWrapper<MVDataContainer<MVCharacter>>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}


extension String {
    ///
    /// Build the full endpoint request url string with the api key and hash,
    /// - ts - a timestamp (or other long string which can change on a request-by-request basis)
    /// - hash - a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)
    ///
    var marvelFullEndPoint: String {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = (timestamp + MarvelAPI.privateKey + MarvelAPI.publicKey).MD5
        return MarvelAPI.baseURLString + self + "?ts=\(timestamp)" + "&apikey=\(MarvelAPI.publicKey)" + "&hash=\(hash)"
    }
}

