//
//  EpisodeCharactersCollectionCell.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/5/24.
//

import UIKit

class EpisodeCharactersCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    private var idCell: Int?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        self.layer.cornerRadius = 50
        imageView.contentMode = .scaleToFill
    }

    func configure(data: EpisodeCharactersCollectionCellModel) {
        idCell = data.id
        imageView.loadImageUsingCache(withUrl: data.image)
    }
    
    func getID() -> Int? {
        return idCell
    }
}
