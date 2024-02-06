//
//  CharacterDetailsViewController.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/2/24.
//

import UIKit

protocol CharacterDetailsDelegate: AnyObject {
    func didDismiss()
}

protocol CharacterDetailsPresenterDelegate: AnyObject {
    func setupView()
    func getNumberOfCells() -> Int
    func getCellBy(row: Int) -> EpisodeViewCellModel?
}

class CharacterDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: CharacterDetailsDelegate?
    var presenter: CharacterDetailsPresenterDelegate?
    var dataStore: CharacterDetailsDataStore?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didDismiss()
    }
    
    func setupPresenter() {
        let setupPresenter = CharacterDetailsPresenter()
        setupPresenter.view = self
        self.dataStore = setupPresenter
        presenter = setupPresenter
    }
}

extension CharacterDetailsViewController: CharacterDetailsViewDelegate {
    
    func setupView() {
        view.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        
        imageView.contentMode = .scaleAspectFill
        
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
                
        tableView.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: EpisodeViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EpisodeViewCell.self))
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setImage(image: String) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.loadImageUsingCache(withUrl: image)
        }
    }
    
    func setNameCharacter(name: String) {
        nameLabel.text = name
    }
    
    func setGender(gender: String) {
        genderLabel.text = "Gender: \(gender)"
    }
    
    func setStatus(status: String) {
        statusLabel.text = "Status: \(status)"
    }
    
    func setLocation(location: String) {
        locationLabel.text = "Location: \(location)"
    }
    
    func setOrigin(origin: String) {
        originLabel.text = "Origin: \(origin)"
    }
    
}

extension CharacterDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getNumberOfCells() ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getCellBy(row: section)?.episode

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeViewCell.self), for: indexPath) as? EpisodeViewCell else { return UITableViewCell() }
        cell.collectionView.tag = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


protocol CharacterDetailsRouterDelegate: AnyObject {
    func navigateToBack()
}

extension CharacterDetailsViewController: CharacterDetailsRouterDelegate {

    func navigateToBack() {
        delegate?.didDismiss()
        dismiss(animated: true)
    }
}

