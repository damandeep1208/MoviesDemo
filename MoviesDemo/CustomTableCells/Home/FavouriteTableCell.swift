//
//  FavouriteTableCell.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/22/22.
//

import UIKit

class FavouriteTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie]?
    var bannerTapped: ((Movie) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        let nib = UINib(nibName: "FavouriteCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FavouriteCollectionCell")
    }
    
    func setupData(data: [Movie]) {
        self.movies = data
        self.collectionView.reloadData()
    }
}

//MARK: CollectionViewDataSource and CollectionViewDelegate implementations
extension FavouriteTableCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(self.movies?.count ?? 0, 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionCell", for: indexPath) as? FavouriteCollectionCell else {
            return UICollectionViewCell()
        }
        guard let model = self.movies?[indexPath.row] else { return cell}
        cell.setupData(model: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FavouriteCollectionCell.width, height: FavouriteCollectionCell.height)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = self.movies?[indexPath.row] else { return }
        bannerTapped?(model)
    }
}
