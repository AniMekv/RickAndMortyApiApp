//
//  EpisodeCellPresenter.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/5/24.
//

import Foundation
import UIKit

protocol EpisodeCellViewDelegate: AnyObject {
    func setupView()
    func reloadTable()
}

protocol EpisodeCellDataStore {
    var episode: Episode? { get set }
}

class EpisodeCellPresenter: EpisodeCellPresenterDelegate, EpisodeCellDataStore {
    weak var view: (EpisodeCellViewDelegate & EpisodeCellRouterDelegate)?
    
    var repository: RickAndMortyRepository = RickAndMortyAPIRepository()
    private var characters: [Character?] = []
    var episode: Episode?
    
    func setupView() {
        view?.setupView()
        getAllCharacters()
    }
    
    // MARK: Private Methods.
    private func getAllCharacters() {
        guard let episode = episode else { return }
        
        let distchPatch = DispatchGroup()
        
        for character in episode.characters {
            distchPatch.enter()
                                 
            repository.getCharacter(character: character ?? "", completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.characters.append(data)
                case .failure(_):
                    print("error")
                }
                distchPatch.leave()
            })
        }
        
        distchPatch.notify(queue: .main, execute: { [weak self] in
            self?.view?.reloadTable()
        })
    }
    
    // MARK: TableView Methods
    
    func getNumberOfCells() -> Int {
        return characters.count
    }
    
    func getCellBy(row: Int) -> EpisodeCharactersCollectionCellModel? {
        guard let character = characters[row], let characterImage = character.image, let id = character.id else { return nil }

        return EpisodeCharactersCollectionCellModel(id: id, image: characterImage)
    }

    func didSelectedCell(id: Int?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.NavigationsName.characterDetails, bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.NavigationsName.characterDetails) as? CharacterDetailsViewController else { return }

        guard let id = id, let character = characters.filter({ $0?.id == id }).first, let character = character  else { return }
        view?.navigateToCharacterDetails(character: character, vc: viewController)
    }
}
