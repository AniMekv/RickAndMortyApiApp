//
//  CharacterDetailsPresenter.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/3/24.
//

import Foundation

protocol CharacterDetailsViewDelegate: AnyObject {
    func setupView()
    func reloadTable()
    func setImage(image: String)
    func setNameCharacter(name: String)
    func setGender(gender: String)
    func setStatus(status: String)
    func setLocation(location: String)
    func setOrigin(origin: String)
}

protocol CharacterDetailsDataStore {
    var character: Character? { get set }
}

class CharacterDetailsPresenter: CharacterDetailsPresenterDelegate, CharacterDetailsDataStore {
    weak var view: (CharacterDetailsViewDelegate & CharacterDetailsRouterDelegate)?
    
    var repository: RickAndMortyRepository = RickAndMortyAPIRepository()
    private var episodes: [Episode?] = []
    var character: Character?
    
    func setupView() {
        view?.setupView()
        setDataCharacter()
        getAllEpisodes()
    }

    private func getAllEpisodes() {
        guard let character = character else { return }
        
        let distchPatch = DispatchGroup()
        
        for episode in character.episode {
            distchPatch.enter()
                                 
            repository.getEpisode(episode: episode ?? "", completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.episodes.append(data)
                case .failure(_):
                    self?.view?.navigateToBack()
                }
                distchPatch.leave()
            })
        }
        
        distchPatch.notify(queue: .main, execute: { [weak self] in
            self?.view?.reloadTable()
        })
    }
    
    private func setDataCharacter() {
        guard let character = character else { return }
        view?.setNameCharacter(name: character.name ?? "")
        view?.setImage(image: character.image ?? "")
        view?.setGender(gender: character.gender ?? "")
        view?.setStatus(status: character.status ?? "")
        view?.setOrigin(origin: character.origin?.name ?? "")
        view?.setLocation(location: character.location?.name ?? "")
    }
    
    // MARK: Table Methods
    
    func getNumberOfCells() -> Int {
        return episodes.count
    }
    
    func getCellBy(row: Int) -> EpisodeViewCellModel? {
        guard let episode = episodes[row], let numEpisode = episode.episode,
              let name = episode.name, let date = episode.air_date else { return nil }
        return EpisodeViewCellModel(episode: numEpisode, name: name, date: date)
    }
}
