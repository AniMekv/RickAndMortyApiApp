//
//  InitialViewController.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/1/24.
//

import UIKit

protocol InitialPresenterDelegate: AnyObject {
    func setupView()
    func filterByText(text: String)
    func getNumberOfCells() -> Int
    func getCellBy(row: Int) -> CharacterCollectionCellModel?
    func didSelectedCell(id: Int?)
    func collectionViewDidMadeRefreshGesture()
}

class InitialViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    var presenter: InitialPresenterDelegate?

    override func loadView() {
        super.loadView()
        let setupPresenter = InitialPresenter()
        setupPresenter.view = self
        presenter = setupPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
        
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func didScrollUntilBottom(_ scrollView: UIScrollView) -> Bool {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        return offsetY > contentHeight - height
    }
    
}

extension InitialViewController: InitialViewDelegate {
    
    func setupView() {
        view.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        
        searchBar.placeholder = NSLocalizedString("initial.search.placeholder", comment: "")
        searchBar.delegate = self

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        navigationBar.topItem?.title = NSLocalizedString("initial.tab.title", comment: "")
        
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 25
        collectionView.register(UINib(nibName: String(describing: CharacterCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CharacterCollectionCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension InitialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfCells() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataCell = presenter?.getCellBy(row: indexPath.row),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCollectionCell.self), for: indexPath) as? CharacterCollectionCell
        else { return UICollectionViewCell() }
        
        cell.configure(data: dataCell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionCell else { return }
        presenter?.didSelectedCell(id: cell.getID())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 16.0
        let numberOfItemsPerRow: CGFloat = 2.0

        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // MARK: Private Methods
    @objc private func refreshCollectionView() {
        
        presenter?.collectionViewDidMadeRefreshGesture()
        
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(didScrollUntilBottom(scrollView)) {
            presenter?.setupView()
        }
    }
}

extension InitialViewController: CharacterDetailsDelegate {
    
    func didDismiss() {
        reloadTable()
    }
}

extension InitialViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterByText(text: searchText.lowercased())
    }
}

protocol InitialRouterDelegate: AnyObject {
    func navigateToCharacterDetails(character: Character)
}

extension InitialViewController: InitialRouterDelegate {
    
    func navigateToCharacterDetails(character: Character) {
        if ((self.presentedViewController as? CharacterDetailsViewController) != nil) {
            dismiss(animated: true)
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.NavigationsName.characterDetails, bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.NavigationsName.characterDetails) as? CharacterDetailsViewController else { return }
        
        viewController.dataStore?.character = character
        viewController.delegate = self
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

