//
//  SeeAllCollectionCell.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/29/22.
//

import UIKit

typealias EmptyBlock = () -> ()

class SeeAllCollectionCell: UICollectionViewCell {

    var seeAllTapped: EmptyBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func seeAllTapped(_ sender: Any) {
        seeAllTapped?()
    }
}
