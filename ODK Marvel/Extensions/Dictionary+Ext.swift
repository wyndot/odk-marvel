//
//  Dictionary+Ext.swift
//  ODK Marvel
//
//  Created by wyndot on 1/21/22.
//

import Foundation

extension Dictionary where Key == String, Value == String  {
    
    ///
    /// Build URL Query string
    /// 
    var queryString: String {
        self.reduce("") { partialResult, pair  in
            partialResult + "&\(pair.key)" + "=\(pair.value)"
        }.URLQueryEscaping
    }
}
