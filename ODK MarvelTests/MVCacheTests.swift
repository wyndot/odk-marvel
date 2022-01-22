//
//  MVCacheTests.swift
//  ODK MarvelTests
//
//  Created by wyndot on 1/22/22.
//

import XCTest
@testable import ODK_Marvel

class MVCacheTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCache() throws {
        let cache = MVCache<String, String>()
        
        let val1 = cache["key1"]
        XCTAssertNil(val1)
        
        cache["key2"] = "val2"
        let val2 = cache["key2"]
        XCTAssertEqual(val2, "val2")
        
        cache["key2"] = "val3"
        let val3 = cache["key2"]
        XCTAssertEqual(val3, "val3")
        
        cache["key2"] = nil
        let val4 = cache["key2"]
        XCTAssertNil(val4)
        
    }

}
