//
//  CharacterCollectionCell.swift
//  RickAndMortyApiApp
//
//  Created by Ani Mekvabidze on 2/5/24.
//

import UIKit

class CharacterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    private var idCell: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        self.layer.cornerRadius = 25
        
        imageView.contentMode = .scaleToFill
        
        nameText.textAlignment = .center
        nameText.textColor = .white
        nameText.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        nameText.numberOfLines = 2
        nameText.lineBreakMode = .byWordWrapping
        nameText.font = UIFont.boldSystemFont(ofSize: 16.0)
        
    }

    func configure(data: CharacterCollectionCellModel) {
        idCell = data.id
        imageView.loadImageUsingCache(withUrl: data.image)
        nameText.text = data.name
    }
    
    func getID() -> Int? {
        return idCell
    }
}
