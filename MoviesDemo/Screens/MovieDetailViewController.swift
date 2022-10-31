//
//  MovieDetailViewController.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/26/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //MARK:- Variables
    var movie: Movie!
    var contentWidth: CGFloat = 0
    
    //MARK:- Outlets
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var imgDirector: UIImageView!
    @IBOutlet weak var viewRating: UIStackView!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblRevenue: UILabel!
    @IBOutlet weak var lblOriginalLanguage: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var cvGeneres: UICollectionView!
    @IBOutlet weak var cvActors: UICollectionView!
    @IBOutlet weak var constraintHeightCVGeneres: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightCVActors: NSLayoutConstraint!
    
    //MARK:- View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    //MARK:- setup UI
    func setupData() {
        
        //movie image
        if let urlStr = movie.posterUrl, let url = URL(string: urlStr) {
            imgMovie.sd_setImage(with: url, placeholderImage: nil)
        }
        
        //movie rating
        let rating = Int(movie.rating ?? 0)
        for view in viewRating.subviews {
            if let imageView = view as? UIImageView {
                if imageView.tag <= rating {
                    imageView.image = UIImage.starSelected
                }
                else {
                    imageView.image = UIImage.starGrey
                }
            }
        }
        
        //release date and duration
        let backendDateFormatter = DateFormatter()
        backendDateFormatter.dateFormat = "yyyy-MM-dd"
        var releaseDate = ""
        if let date = backendDateFormatter.date(from: movie.releaseDate ?? "") {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.MM.yyyy"
            releaseDate = dateformatter.string(from: date)
        }
        let runtime = movie.runtime ?? 0
        let hours = runtime / 60
        let minutes = (runtime % 60)
        lblReleaseDate.text = "\(releaseDate) · \(hours)h \(minutes)m"
        //movie details
        lblTitle.text = movie.title
        lblYear.text = "(\(String(movie.releaseDate?.prefix(4) ?? "")))"
        lblOverview.text = movie.overview
        
        //director details
        lblDirector.text = movie.director?.name
        if let urlStr = movie.director?.pictureUrl, let url = URL(string: urlStr) {
            imgDirector.sd_setImage(with: url, placeholderImage: nil)
        }
        
        //key facts
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        if let budget = formatter.string(from: (movie.budget ?? 0) as NSNumber) {
            lblBudget.text = budget
        }
        if let revenue = formatter.string(from: (movie.revenue ?? 0) as NSNumber) {
            lblRevenue.text = revenue
        }
        let locale =  NSLocale(localeIdentifier: movie.language ?? "en")
        let fullName = locale.localizedString(forLanguageCode: movie.language ?? "en")!
        lblOriginalLanguage.text = fullName
        lblRating.text = "\(String(format: "%.2f", movie.rating ?? 0)) (\(movie.reviews ?? 0))"
        
        btnBookmark.isSelected = DataStorage.isBookMarked(movieId: self.movie.id!)

    }
    
    func updateLayout(){
        let height = cvGeneres.collectionViewLayout.collectionViewContentSize.height
        constraintHeightCVGeneres.constant = height
        
        //center align generes
        if contentWidth > self.cvGeneres.frame.size.width {
            cvGeneres.contentInset = UIEdgeInsets.zero
        } else {
            cvGeneres.contentInset = UIEdgeInsets(top: 0, left: (self.cvGeneres.frame.size.width - contentWidth) / 2.0, bottom: 0, right: 0)
        }
    }
    
    //MARK:- Button Actions
    @IBAction func bookmarkPressed(_ sender: UIButton) {
        guard let movieId = self.movie.id else { return }
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
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: CollectionViewDataSource and CollectionViewDelegate implementations
extension MovieDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvGeneres {
            return movie.genres?.count ?? 0
        }
        return movie.cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvGeneres {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionCell", for: indexPath) as? GenresCollectionCell else {
                return UICollectionViewCell()
            }
            cell.lblGenre.text = movie.genres?[indexPath.row] ?? ""
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCastCollectionCell", for: indexPath) as? MovieCastCollectionCell else {
            return UICollectionViewCell()
        }
        guard let model = self.movie.cast?[indexPath.row] else { return cell}
        cell.setupData(model: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvGeneres {
            let generText = movie.genres?[indexPath.row] ?? ""
            let size = generText.size(withAttributes:[.font: UIFont.systemFont(ofSize: 14, weight: .light)])
            if indexPath.row == 0 {
                contentWidth = 0
            }
            contentWidth += size.width + 22
            return CGSize(width: size.width, height: 21)
        }
        return CGSize(width: 100, height: 150)

    }

}
