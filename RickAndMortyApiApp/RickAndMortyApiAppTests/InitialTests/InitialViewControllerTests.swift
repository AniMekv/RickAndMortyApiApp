//
//  InitialViewControllerTests.swift
//  RickAndMortyApiAppTests
//
//  Created by Ani Mekvabidze on 2/6/24.
//

import Foundation
@testable import RickAndMortyApiApp
import XCTest

class InitialViewControllerTests: XCTestCase {
    
    var sut: InitialViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    private func setupController() {
        let storyboard = UIStoryboard(name: Constants.NavigationsName.initial, bundle: Bundle.main)
        sut = storyboard.instantiateInitialViewController() as? InitialViewController
        sut.loadView()
    }
    
    func loadView(isNavigation: Bool = false) {
        window.addSubview(sut.view)
        if isNavigation {
            window.rootViewController = UINavigationController(rootViewController: sut)
        }
        RunLoop.current.run(until: Date())
    }
    
    class InitialPresenterSpy: InitialPresenterDelegate {
        
        
        var setupViewCalled = false
        var getNumberOfCellsCalled = false
        var getCellByCalled = false
        var didSelectedCellCalled = false
        var filterByTextCalled = false
        var collectionViewDidRefresh = false
        
        func setupView() {
            setupViewCalled = true
        }
        
        func getNumberOfCells() -> Int {
            getNumberOfCellsCalled = true
            return 1
        }
        
        func getCellBy(row: Int) -> CharacterCollectionCellModel? {
            getCellByCalled = true
            return CharacterCollectionCellModel(id: 0, image: "", name: "test")
        }
        
        func didSelectedCell(id: Int?) {
            didSelectedCellCalled = true
        }
        
        func filterByText(text: String) {
            filterByTextCalled = true
        }
        
        func collectionViewDidMadeRefreshGesture() {
            collectionViewDidRefresh = true
        }
    }
        
    func testFilteredBtn() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        sut.filteredBtn(UIButton())
        
        XCTAssertTrue(spy.modeOnlyScoredCalled)
    }
    
    func testSearchBar() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        sut.searchBar(UISearchBar(), textDidChange: "test")
        
        XCTAssertTrue(spy.filterByTextCalled)
    }
    
    func testNavigateToCharacterDetails() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        loadView(isNavigation: true)
        sut.navigateToCharacterDetails(character: Character(id: 2, name: "", status: "", species: "", type: "", gender: "", origin: Origin(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: ""))
        
        XCTAssertTrue(sut.navigationController?.presentationController != nil)
    }
}
