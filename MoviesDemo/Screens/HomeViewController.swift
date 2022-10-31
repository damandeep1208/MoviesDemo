//
//  ViewController.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/22/22.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var favouries: [Movie] = []
    var movies: [Movie] = []
    var staffPicks: [Movie] = []
    var viewModel: HomeViewModel? {
        didSet {
            self.viewModel?.delegate = self
        }
    }
    
    //MARK:- View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        self.viewModel = HomeViewModel()
        self.viewModel?.getMovies()
        self.viewModel?.getStaffPicks()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBookmars), name: Notification.Name.bookmarkUpdated, object: nil)
    }
    
    //MARK:- UI setup
    func setupUI() {
        // Register the custom header view and table cells
        let nib = UINib(nibName: "HomeHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        
        let favCell = UINib(nibName: "FavouriteTableCell", bundle: nil)
        tableView.register(favCell, forCellReuseIdentifier: "FavouriteTableCell")
        
        let moviesCell = UINib(nibName: "MovieTableCell", bundle: nil)
        tableView.register(moviesCell, forCellReuseIdentifier: "MovieTableCell")
        
        tableView.tableHeaderView = tableHeaderView
        
        //add background imageview sticked with header
        let image = UIImage.Backgroundbg
        let imageView = UIImageView(image: image!)
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: tableHeaderView.safeAreaLayoutGuide.bottomAnchor, constant: FavouriteCollectionCell.height/3.0 + HomeHeaderView.height),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    //MARK:- Functionalities
    @objc func updateBookmars() {
        //update bookmarked items UI
        getSavedFavorites()
        tableView.reloadData()
    }
    
    func getSavedFavorites() {
        let savedFavourites = DataStorage.bookmarkedItems()
        favouries = movies.filter({item  in savedFavourites.contains(item.id!) })
    }
    
    //MARK:- Segues
    func showSearchScreen(fav: Bool, movies: [Movie]) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
        vc.allMovies = movies
        vc.searchFav = fav
        self.show(vc, sender: self)
    }
    
    func showMovieDetail(movie: Movie) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movie = movie
        self.present(vc, animated: true, completion: nil)
    }

    //MARK:- Button Actions
    @IBAction func btnActionSearch(_ sender: Any) {
       showSearchScreen(fav: false, movies: movies)
    }
}

//MARK:- UITableView dataSource and delegates
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = HomePageSections(rawValue: section) else {
            return 0
        }
        switch sectionType {
        case .favourites:
            return favouries.count > 0 ? 1 : 0
        default:
            return staffPicks.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else { return nil }
        guard let sectionType = HomePageSections(rawValue: section) else {
            return sectionHeaderView
        }
        sectionHeaderView.configureFor(type: sectionType, favIsEmpty: favouries.isEmpty)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = HomePageSections(rawValue: section) else {
            return 0
        }
        switch sectionType {
        case .favourites:
            return favouries.count > 0 ? HomeHeaderView.height : 0
        default:
            return staffPicks.count > 0 ? HomeHeaderView.height : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = HomePageSections(rawValue: indexPath.section) else {
            return 0
        }
        switch sectionType {
        case .favourites:
            return FavouriteCollectionCell.height + 45
        default:
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = HomePageSections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch sectionType {
        case .favourites:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableCell") as? FavouriteTableCell else {
                return UITableViewCell()
            }
            cell.setupData(data: self.favouries)
            cell.bannerTapped = { [weak self] movie in
                self?.showMovieDetail(movie: movie)
            }
            cell.seeAllFavouritesTapped = { [weak self] in
                self?.showSearchScreen(fav: true, movies: self?.favouries ?? [])
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell") as? MovieTableCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor.clear
            cell.setupData(model: self.staffPicks[indexPath.row], whiteMode: favouries.isEmpty && indexPath.row == 0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = HomePageSections(rawValue: indexPath.section) else {
            return
        }
        if sectionType == .favourites { return }
        
        showMovieDetail(movie: staffPicks[indexPath.row])
    }
    
}

//MARK:- APIs response handling
extension HomeViewController: HomeViewModelProtocol {
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .getMoviesResponse(let response):
            self.movies = response ?? []
            getSavedFavorites()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .getStaffPicksResponse(let response):
            self.staffPicks = response ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
