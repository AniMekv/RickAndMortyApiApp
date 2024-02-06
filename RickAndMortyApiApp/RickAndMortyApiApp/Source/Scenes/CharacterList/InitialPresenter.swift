//
//  InitialPresenter.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/2/24.
//

import Foundation

protocol InitialViewDelegate: AnyObject {
    func setupView()
    func reloadTable()
}

class InitialPresenter: InitialPresenterDelegate {
    weak var view: (InitialViewDelegate & InitialRouterDelegate)?
    
    var repository: RickAndMortyRepository = RickAndMortyAPIRepository()
    private var characters: [Character?] = []
    private var filteredCells: [Character?] = []
    private var isFiltered: Bool = false
    private var lastSearch: String = ""
        
    private var currentPage = 1
    
//     MARK: Public Methods.

    func collectionViewDidMadeRefreshGesture() {
        refresh()
    }

    func getCharacters(page: Int?) {
        currentPage += 1
        let currentPageString = String(currentPage)
        if currentPageString <= Constants.EndPoints.LAST_PAGE_INDEX {
            repository.getCharactersPage(page: page ?? 0) {[weak self] result in
                if case let .success(data) = result {
                    let newCharacterList = (self?.characters ?? []) + data
                    self?.characters = newCharacterList
                    self?.filteredCells = newCharacterList
                    DispatchQueue.main.async {

                        self?.view?.reloadTable()
                    }

                }
            }
        }
    }

    private func refresh() {

        currentPage = 1
        let page = currentPage

        repository.getCharactersPage(page: page) {[weak self] result in
            if case let .success(data) = result {
                self?.characters = data
                self?.filteredCells = data
                DispatchQueue.main.async {
                    self?.view?.reloadTable()
                }

            }
        }
    }

    
    func setupView() {
        view?.setupView()
        getCharacters(page: currentPage)
    }
    
    func filterByText(text: String) {
        filteredCells.removeAll()
        lastSearch = text
        
        guard !text.isEmpty else {
            filteredCells = characters
            filterByStart()
            return
        }
        
        characters.forEach({
            if $0?.name?.lowercased().contains(text) == true {
                filteredCells.append($0)
            }
        })
        
        if isFiltered {
            filterByStart()
        } else {
            view?.reloadTable()
        }
    }
    
    private func filterByStart() {
        guard isFiltered else {
            view?.reloadTable()
            return
        }
        
        view?.reloadTable()
    }
    
    
    // MARK: Collection Methods
    
    func getNumberOfCells() -> Int {
        return filteredCells.count
    }
    
    func getCellBy(row: Int) -> CharacterCollectionCellModel? {
        guard let character = filteredCells[row], let characterImage = character.image,
              let characterName = character.name, let id = character.id else { return nil }
        return CharacterCollectionCellModel(id: id, image: characterImage, name: characterName)
    }
    
    func didSelectedCell(id: Int?) {
        guard let id = id, let character = characters.filter({ $0?.id == id }).first, let character = character  else { return }
        view?.navigateToCharacterDetails(character: character)
    }
}
