//
//  CharacterDetailsPresenterTests.swift
//  RickAndMortyApiAppTests
//
//  Created by Ani Mekvabidze on 2/6/24.
//

import Foundation
@testable import RickAndMortyApiApp
import XCTest

class CharacterDetailsPresenterTests: XCTestCase {
    
    var sut: CharacterDetailsPresenter!
    
    override func setUp() {
        super.setUp()
        setupPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupPresenter() {
        sut = CharacterDetailsPresenter()
    }
    
    class CharacterDetailsPresenterSpy: CharacterDetailsViewDelegate, CharacterDetailsRouterDelegate {
        
        var setupViewCalled = false
        var reloadTableCalled = false
        var setImageCalled = false
        var setGenderCalled = false
        var setStatusCalled = false
        var setLocationCalled = false
        var setOriginCalled = false
        var setNameCharacterCalled = false
        var navigateToBackCalled = false
        
        func setupView() {
            setupViewCalled = true
        }
        
        func reloadTable() {
            reloadTableCalled = true
        }
        
        func setImage(image: String) {
            setImageCalled = true
        }
        
        func setNameCharacter(name: String) {
            setNameCharacterCalled = true
        }
        
        func setGender(gender: String) {
            setGenderCalled = true
        }
        
        func setStatus(status: String) {
            setStatusCalled = true
        }
        
        func setLocation(location: String) {
            setLocationCalled = true
        }
        
        func setOrigin(origin: String) {
            setOriginCalled = true
        }
        
        func navigateToBack() {
            navigateToBackCalled = true
        }
    }
    
    class RickAndMorttyyRepositorySpy: RickAndMorttyyAPIRepository {
        var isFailure: Bool = false
        
        override func getEpisode(episode: String, completion: @escaping (Result<Episode, FactorError>) -> ()) {
            if isFailure {
                completion(.failure(.url))
            } else {
                let data = Episode(id: 1, name: "test", air_date: "", episode: "", characters: [""], url: "", created: "")
                completion(.success(data))
            }
        }
    }
    
    func testSetup() {
        let spy = CharacterDetailsPresenterSpy()
        sut.view = spy
        
        sut.setupView()
        
        XCTAssertTrue(spy.setupViewCalled)
    }
    
    func testSetupWithServiceSuccess() {
        let spy = CharacterDetailsPresenterSpy()
        sut.view = spy
        sut.repository = RickAndMorttyyRepositorySpy()
        sut.character = Character(episode: [""])
        
        sut.setupView()
        waitUI(withDelay: 2)
        let result = sut.getCellBy(row: 0)
        
        XCTAssertTrue(spy.reloadTableCalled)
        XCTAssertEqual(result?.name, "test")
    }
    
    func testSetupWithServiceFailure() {
        let spy = CharacterDetailsPresenterSpy()
        sut.view = spy
        let repoSpy = RickAndMorttyyRepositorySpy()
        repoSpy.isFailure = true
        sut.repository = repoSpy
        sut.character = Character(episode: [""])
        
        sut.setupView()
        
        XCTAssertTrue(spy.navigateToBackCalled)
    }
    
    func testSetupWithData() {
        let spy = CharacterDetailsPresenterSpy()
        sut.view = spy
        sut.character = Character(id: 2, name: "", status: "", species: "", type: "", gender: "", origin: Origin(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: "")
        
        sut.setupView()
        
        XCTAssertTrue(spy.setImageCalled)
        XCTAssertTrue(spy.setGenderCalled)
        XCTAssertTrue(spy.setStatusCalled)
        XCTAssertTrue(spy.setOriginCalled)
        XCTAssertTrue(spy.setLocationCalled)
    }
    
    func testGetNumberOfCells() {
        let spy = CharacterDetailsPresenterSpy()
        sut.view = spy
        let expectedResult = 0
        
        let result = sut.getNumberOfCells()
        
        XCTAssertEqual(result, expectedResult)
    }
    
    
    private func waitUI(withDelay: Double = 0) {
        let uiExpectation = expectation(description: "UI Waiting")
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
            uiExpectation.fulfill()
        }
        
        waitForExpectations(timeout: withDelay + 100, handler: nil)
    }
}
