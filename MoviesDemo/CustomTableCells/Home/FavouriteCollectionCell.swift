//
//  FavouriteCollectionCell.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/22/22.
//

import UIKit
import SDWebImage

class FavouriteCollectionCell: UICollectionViewCell {

    static let width = UIScreen.main.bounds.width/2.0
    static let height = width * 1.5
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(model: Movie) {
        if let urlStr = model.posterUrl, let url = URL(string: urlStr) {
            imageView.sd_setImage(with: url, placeholderImage: nil)
        }
        else {
            imageView.image = nil
        }
    }

}
