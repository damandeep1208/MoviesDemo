//
//  MovieCastCollectionCell.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/28/22.
//

import UIKit

class MovieCastCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCharacter: UILabel!
    
    func setupData(model: User) {
        lblName.text = model.name
        lblCharacter.text = model.character
        if let urlStr = model.pictureUrl, let url = URL(string: urlStr) {
            imgProfile.sd_setImage(with: url, placeholderImage: nil)
        }
        else {
            imgProfile.image = nil
        }
    }
}
