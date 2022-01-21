//
//  MVAPITests.swift
//  ODK MarvelTests
//
//  Created by wyndot on 1/21/22.
//

import XCTest
import Combine
@testable import ODK_Marvel

class MVAPITests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func testGetCharacters() throws {
        
        var results: MVDataWrapper<MVDataContainer<MVCharacter>>?
        let expectation = self.expectation(description: "Characters")
        var error: Error?
        
        MarvelAPI.getCharacters(limit: 10, offset: 2)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                error = err
            }
            expectation.fulfill()
        } receiveValue: { datawrapper  in
            results = datawrapper
        }
            .store(in: &cancellables)
        
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNil(error)
        XCTAssertNotNil(results?.data?.results)
        XCTAssertEqual(results?.data?.results?.count, 10)
        XCTAssertEqual(results?.data?.limit, 10)
        XCTAssertEqual(results?.data?.offset, 2)
        
    }
}
