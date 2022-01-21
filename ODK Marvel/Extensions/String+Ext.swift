//
//  String+Ext.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation
import CryptoKit

extension String {
    ///
    /// Hash the string with MD5 algorithm
    ///
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0)}.joined()
    }
    
    ///
    /// Escaping the URL Query string
    ///
    var URLQueryEscaping: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
