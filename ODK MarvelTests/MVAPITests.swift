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
        
        MarvelAPI.getCharacters(offset: 2, limit: 10)
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
    
    func testFullSizeImage() throws {
        
        let expectation = self.expectation(description: "fullsize")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .fullSize, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testLandscapeLargeImage() throws {
        
        let expectation = self.expectation(description: "landscape large")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .landscapeLarge, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testLandscapeSmallImage() throws {
        
        let expectation = self.expectation(description: "landscape small")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .landscapeSmall, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testPortraitSmallImage() throws {
        
        let expectation = self.expectation(description: "portrait small")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .portraitSmall, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testPortraitLargeImage() throws {
        
        let expectation = self.expectation(description: "portrait large")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .portraitLarge, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testSquareLargeImage() throws {
        
        let expectation = self.expectation(description: "square large")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .squareLarge, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testSquareSmallImage() throws {
        
        let expectation = self.expectation(description: "square small")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", variant: .squareSmall, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNotNil(image)
    }
    
    func testInvalidImage() throws {
        
        let expectation = self.expectation(description: "square small")
        var image: UIImage? = nil
        
        MarvelAPI.getImage(path: "https://invalid.url.com", variant: .squareSmall, ext: "jpg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                   expectation.fulfill()
                }
                
            } receiveValue: { result  in
                image = result
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 60)
        
        XCTAssertNil(image)
    }
}
