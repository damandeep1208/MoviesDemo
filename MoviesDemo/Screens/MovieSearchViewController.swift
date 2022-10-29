//
//  MovieSearchViewController.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/26/22.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet var ratingFilterViews: [UIStackView]!
    @IBOutlet var ratingFilterButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoMovie: UIView!
    
    var movies:[Movie] = [] {
        didSet {
            //update UI when movies are filtered
            reloadTableData()
        }
    }
    var allMovies:[Movie] = []
    var selectedRating: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tfSearch.attributedPlaceholder = NSAttributedString(
            string: "Search all movies",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)]
        )
        
        let moviesCell = UINib(nibName: "MovieTableCell", bundle: nil)
        tableView.register(moviesCell, forCellReuseIdentifier: "MovieTableCell")
        
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))

        resetFilters()
        self.movies = allMovies
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Do your thang here!
            self.view.endEditing(true)
            for textField in self.view.subviews where textField is UITextField {
                textField.resignFirstResponder()
            }
        }
        sender.cancelsTouchesInView = false
    }
    
    func resetFilters() {
        for view in ratingFilterViews {
            view.subviews.forEach({ ($0 as! UIImageView).image = UIImage(named: "starWhite")})
        }
    }
    
    func applyFilters(searchText: String?) {
        var results: [Movie] = allMovies
        
        if let text = searchText, !text.isEmpty{
            results = results.filter({
                $0.title?.lowercased().range(of:text, options: .caseInsensitive) !=  nil
            })
        }
        if let rating = selectedRating {
            results = results.filter({ Int($0.rating ?? 0) == rating })
        }
        movies = results
    }
    
    func reloadTableData() {
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        viewNoMovie.isHidden = !movies.isEmpty
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingFilterPressed(_ sender: UIButton) {
        //update selected rating UI
        let tag = sender.tag
        resetFilters()
        if sender.isSelected && sender.tag == selectedRating {
            sender.isSelected = false
            selectedRating = nil
        }
        else {
            ratingFilterButtons.forEach({$0.isSelected = false})
            //update selected rating UI
            guard let view = ratingFilterViews.first(where: { $0.tag == tag }) else { return }
            view.subviews.forEach({ ($0 as! UIImageView).image = UIImage(named: "starSelected")})
            //store button selected state
            sender.isSelected = true
            //save selected rating to use while searching text and selected rating both
            selectedRating = tag
        }

        
        applyFilters(searchText: tfSearch.text)
    }
}

extension MovieSearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            self.view.endEditing(true)
            return true
        }
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            //filter searched text
            applyFilters(searchText: updatedText)
        }
        return true
    }
    
}

//MARK: UITableView dataSource and delegates
extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell") as? MovieTableCell else {
            return UITableViewCell()
        }
        cell.setupData(model: self.movies[indexPath.row])
        cell.bookmarkUpdated = {
            NotificationCenter.default.post(Notification(name: .bookmarkUpdated))
        }
        return cell
    }
    
    
}
