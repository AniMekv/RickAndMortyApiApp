//
//  EpisodeViewCell.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/1/24.
//

import UIKit

protocol EpisodeCellPresenterDelegate: AnyObject {
    func setupView()
    func getNumberOfCells() -> Int
    func didSelectedCell(id: Int?)
}

class EpisodeViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var episode: Episodes?
    var presenter: EpisodeCellPresenterDelegate?
    var dataStore: EpisodeCellDataStore?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupPresenter()
        presenter?.setupView()
        
    }
    
    private func setupPresenter() {
        let setupPresenter = EpisodeCellPresenter()
        setupPresenter.view = self
        self.dataStore = setupPresenter
        presenter = setupPresenter
    }
    
}

extension EpisodeViewCell: EpisodeCellViewDelegate {
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: EpisodeCharactersCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: EpisodeCharactersCollectionCell.self))
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}


extension EpisodeViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfCells() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EpisodeCharactersCollectionCell.self), for: indexPath) as? EpisodeCharactersCollectionCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EpisodeCharactersCollectionCell else { return }
        presenter?.didSelectedCell(id: cell.getID())
    }

}


protocol EpisodeCellRouterDelegate: AnyObject {
    func navigateToCharacterDetails(character: Character, vc: UIViewController)
}

extension EpisodeViewCell: EpisodeCellRouterDelegate {

    func navigateToCharacterDetails(character: Character, vc: UIViewController) {
        if ((vc.presentedViewController as? CharacterDetailsViewController) != nil) {
            vc.dismiss(animated: true)
        }

        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.NavigationsName.characterDetails, bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.NavigationsName.characterDetails) as? CharacterDetailsViewController else { return }

        viewController.dataStore?.character = character
        viewController.delegate = vc as? any CharacterDetailsDelegate

        vc.navigationController?.pushViewController(viewController, animated: true)
    }
}
