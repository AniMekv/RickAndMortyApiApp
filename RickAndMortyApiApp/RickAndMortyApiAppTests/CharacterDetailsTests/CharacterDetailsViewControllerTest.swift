//
//  CharacterDetailsViewControllerTest.swift
//  RickAndMortyApiAppTests
//
//  Created by Ani Mekvabidze on 2/6/24.
//

import Foundation
@testable import RickAndMortyApiApp
import XCTest

class CharacterDetailsViewControllerTest: XCTestCase {
    
    var sut: CharacterDetailsViewController!
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
        let storyboard = UIStoryboard(name: Constants.NavigationsName.characterDetails, bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: Constants.NavigationsName.characterDetails) as? CharacterDetailsViewController
        sut.setupPresenter()
    }
    
    func loadView(isNavigation: Bool = false) {
        window.addSubview(sut.view)
        if isNavigation {
            window.rootViewController = UINavigationController(rootViewController: sut)
        }
        RunLoop.current.run(until: Date())
    }
    
    class CharacterDetailsPresenterSpy: CharacterDetailsPresenterDelegate {
        
        var setupViewCalled = false
        var getNumberOfCellsCalled = false
        var getCellByCalled = false

        func setupView() {
            setupViewCalled = true
        }
        
        func getNumberOfCells() -> Int {
            getNumberOfCellsCalled = true
            return 1
        }
        
        func getCellBy(row: Int) -> EpisodeViewCellModel? {
            getCellByCalled = true
            return EpisodeViewCellModel(episode: "", name: "", date: "")
        }
    }
    
    func testSetupView() {
        let spy = CharacterDetailsPresenterSpy()
        sut.presenter = spy
        
        sut.setupView()
        
        XCTAssertTrue(spy.setupViewCalled)
    }
    
    func testSetNameCharacter() {
        let spy = CharacterDetailsPresenterSpy()
        sut.presenter = spy
        let result = "test"
        
        loadView()
        sut.setNameCharacter(name: result)
        
        XCTAssertEqual(sut.nameLabel.text, result)
    }
    
    func testSetGender() {
        let spy = CharacterDetailsPresenterSpy()
        sut.presenter = spy
        let result = "test"
        
        loadView()
        sut.setGender(gender: result)
        
        XCTAssertEqual(sut.genderLabel.text, "Gender: \(result)")
    }
    
    func testSetOrigin() {
        let spy = CharacterDetailsPresenterSpy()
        sut.presenter = spy
        let result = "test"
        
        loadView()
        sut.setOrigin(origin: result)
        
        XCTAssertEqual(sut.originLabel.text, "Origin: \(result)")
    }
    
    func testSetStatus() {
        let spy = CharacterDetailsPresenterSpy()
        sut.presenter = spy
        let result = "test"
        
        loadView()
        sut.setStatus(status: result)
        
        XCTAssertEqual(sut.statusLabel.text, "Status: \(result)")
    }
    
    func testSetLocation() {
        let spy = CharacterDetailsPresenterSpy()
        sut.presenter = spy
        let result = "test"
        
        loadView()
        sut.setLocation(location: result)
        
        XCTAssertEqual(sut.locationLabel.text, "Location: \(result)")
    }
}
