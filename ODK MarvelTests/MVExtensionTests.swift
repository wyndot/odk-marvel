//
//  MVExtensionTests.swift
//  ODK MarvelTests
//
//  Created by wyndot on 1/21/22.
//

import XCTest
@testable import ODK_Marvel

class MVExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringExtMD5() throws {
        let str1 = "ODK+Marvel"
        let str2 = "FailCase"
        let md5 = str1.MD5
        let md5fail = str2.MD5
        let expected = "084ded2b36e11d96c76a752874699220"
        XCTAssertEqual(md5, expected)
        XCTAssertNotEqual(md5fail, expected)
    }
    
    func testStringExtQueryStrinEscaping() throws {
        let str = " <>#%{}|\\^[]`+~;/?:@=&$"
        let escaped = str.URLQueryEscaping
        let expected = "%20%3C%3E%23%25%7B%7D%7C%5C%5E%5B%5D%60+~;/?:@=&$"
        XCTAssertEqual(escaped, expected)
    }
    
    func testDictionaryQueryString() throws {
        let params = ["limit": "10", "offset": "<>#"]
        let queryStr = params.queryString
        XCTAssertTrue(queryStr.contains("&limit=10"))
        XCTAssertTrue(queryStr.contains("&offset=%3C%3E%23"))
        XCTAssertEqual(queryStr.count, 26)
    }
}
