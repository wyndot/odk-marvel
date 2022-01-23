//
//  MarvelAPI.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import UIKit
import Combine
import CryptoKit

struct MarvelAPI {
    
    enum ImageVariant: String  {
        case portraitSmall = "portrait_small"
        case portraitLarge = "portrait_uncanny"
        case squareSmall = "standard_small"
        case squareLarge = "standard_fantastic"
        case landscapeSmall = "landscape_small"
        case landscapeLarge = "landscape_incredible"
        case fullSize = "detail"
        
    }
    
    enum MVAPIError: Error {
        case generic(message: String)
        case statusCodeError(code: Int, message: String)
        case invalidURL
        case invalidImageData
    }
    
    static var cache: MVCache<String, UIImage> = MVCache<String, UIImage>()
    
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
    ///     - path: the endpoint of the marvel api request or image url, example : /v1/public/characters
    ///     - params: query parameters to the endpoint
    /// - returns: URLRequest? the get request, return nil if the endpoint is invalid endpoint string
    ///
    /// - NOTE: params will not cause the func return nil, if the configuration and endpoint string are correct,  func should always return the request
    ///
    static func get(path: String, params: [String: String] = [:]) -> URLRequest? {
        URL(string: (Self.baseURLString + path).marvelSignedRequestString + params.queryString)
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
    static func getCharacters(offset: Int = 0, limit: Int = 50) -> AnyPublisher<MVDataWrapper<MVDataContainer<MVCharacter>>, Error> {
        guard let req = get(path: "/v1/public/characters", params: ["orderBy": "name", "limit": "\(limit)", "offset": "\(offset)"]) else {
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
    
    
    static func getImage(path: String, variant: ImageVariant, ext: String) -> AnyPublisher<UIImage, Error> {
        let actual = "\(path)/\(variant.rawValue).\(ext)"
        guard let url = URL(string: actual) else {
            return Fail<UIImage, Error>(error: MVAPIError.invalidURL).eraseToAnyPublisher()
        }
        
        if let image = Self.cache[actual] {
            return Result.Publisher(image).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw MVAPIError.invalidImageData
                }
                
                Self.cache[path] = image
                return image
            })
            .eraseToAnyPublisher()
    }
}


extension String {
    ///
    /// Build the  request url string with the api key and hash,
    /// - ts - a timestamp (or other long string which can change on a request-by-request basis)
    /// - hash - a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)
    ///
    var marvelSignedRequestString: String {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = (timestamp + MarvelAPI.privateKey + MarvelAPI.publicKey).MD5
        return self + "?ts=\(timestamp)" + "&apikey=\(MarvelAPI.publicKey)" + "&hash=\(hash)"
    }
}

