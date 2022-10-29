//
//  MovieTableCell.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/22/22.
//

import UIKit

class MovieTableCell: UITableViewCell {

    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblReleaseYear: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var ratingView: UIStackView!
    
    var movieId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(model: Movie, whiteMode: Bool) {
        self.movieId = model.id
        lblTitle.text = model.title
        lblReleaseYear.text = String(model.releaseDate?.prefix(4) ?? "")
        if let urlStr = model.posterUrl, let url = URL(string: urlStr) {
            imgMovie.sd_setImage(with: url, placeholderImage: nil)
        }
        else {
            imgMovie.image = nil
        }
        let rating = Int(model.rating ?? 0)
        for view in ratingView.subviews {
            if let imageView = view as? UIImageView {
                if imageView.tag <= rating {
                    imageView.image = UIImage(named: "starSelected")
                }
                else {
                    imageView.image = whiteMode ? UIImage(named: "starGrey") : UIImage(named: "star")
                }
            }
        }
        btnBookmark.isSelected = DataStorage.isBookMarked(movieId: model.id!)
        lblTitle.textColor =  whiteMode ? UIColor(named: "bgColor") : UIColor.white
        lblReleaseYear.textColor =  whiteMode ? UIColor(named: "bgColor") : UIColor.white
        btnBookmark.setImage(UIImage(named: whiteMode ? "bookmarkBlack" : "bookmarkWhite"), for: .normal)
        btnBookmark.setImage(UIImage(named: whiteMode ? "bookmarkBlackSelected" : "bookmarkWhiteSelected"), for: .selected)
    }
    
    @IBAction func addToBookmark(_ sender: UIButton) {
        guard let movieId = self.movieId else { return }
        if DataStorage.isBookMarked(movieId: movieId) {
            DataStorage.removeFromBookMark(movieId: movieId)
            sender.isSelected = false
        }
        else {
            DataStorage.addToBookMark(movieId: movieId)
            sender.isSelected = true
        }
        NotificationCenter.default.post(Notification(name: .bookmarkUpdated))
    }
}
