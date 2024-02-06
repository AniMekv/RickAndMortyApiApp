//
//  InitialPresenterTests.swift
//  RickAndMortyApiAppTests
//
//  Created by Ani Mekvabidze on 2/6/24.
//

import Foundation
@testable import RickAndMortyApiApp
import XCTest

class InitialPresenterTests: XCTestCase {
    
    var sut: InitialPresenter!
    
    override func setUp() {
        super.setUp()
        setupPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupPresenter() {
        sut = InitialPresenter()
    }
    
    class InitialViewControllerSpy: InitialViewDelegate, InitialRouterDelegate {
        
        var setupViewCalled = false
        var reloadTableCalled = false
        var changeIconFilterCalled = false
        var navigateToCharacterDetailsCalled = false
        
        func setupView() {
            setupViewCalled = true
        }
        
        func reloadTable() {
            reloadTableCalled = true
        }
        
        func changeIconFilter(isFiltered: Bool) {
            changeIconFilterCalled = true
        }
        
        func navigateToCharacterDetails(character: Character) {
            navigateToCharacterDetailsCalled = true
        }
    }
    
    class RickAndMorttyyRepositorySpy: RickAndMorttyyAPIRepository {
        
        override func getCharactersPage(page: Int, completion: @escaping (Result<[Character], FactorError>) -> ()) {
            let data = [Character(episode: [""])]
            completion(.success(data))
        }
    }
        
    func testSetup() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        
        sut.setupView()
        
        XCTAssertTrue(spy.setupViewCalled)
    }
    
    func testSetupWithService() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        sut.repository = RickAndMorttyyRepositorySpy()
        
        sut.setupView()
        
        XCTAssertTrue(spy.reloadTableCalled)
    }
    
    func testSetupWithServiceAndDidSelectedCell() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        sut.repository = RickAndMorttyyRepositorySpy()
        
        sut.setupView()
        sut.didSelectedCell(id: 0)
        
        XCTAssertTrue(spy.navigateToCharacterDetailsCalled)
    }
 
    
    func testFilterByText() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        sut.repository = RickAndMorttyyRepositorySpy()
        
        sut.setupView()
        sut.filterByText(text: "test")
        
        XCTAssertTrue(spy.reloadTableCalled)
    }
}
