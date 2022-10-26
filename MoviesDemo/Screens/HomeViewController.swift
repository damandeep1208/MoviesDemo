//
//  ViewController.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/22/22.
//

import UIKit

enum HomePageSections: Int {
    case favourites
    case staffPicks
    
    func title1() -> String {
        switch self {
        case .favourites:
            return "YOUR"
        case .staffPicks:
            return "OUR"
        }
    }
    
    func title2() -> String {
        switch self {
        case .favourites:
            return "FAVORITES"
        case .staffPicks:
            return "STAFF PICKS"
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .favourites:
            return .black
        default:
            return .white
        }
    }
      
}

class HomeViewController: UIViewController {

    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var favouries: [Movie] = []
    var movies: [Movie] = []
    var viewModel: HomeViewModel? {
        didSet {
            self.viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        self.viewModel = HomeViewModel()
        self.viewModel?.getMovies()
        self.viewModel?.getStaffPicks()
    }

    func setupUI() {
        // Register the custom header view.
        let nib = UINib(nibName: "HomeHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        
        let favCell = UINib(nibName: "FavouriteTableCell", bundle: nil)
        tableView.register(favCell, forCellReuseIdentifier: "FavouriteTableCell")
        
        let moviesCell = UINib(nibName: "MovieTableCell", bundle: nil)
        tableView.register(moviesCell, forCellReuseIdentifier: "MovieTableCell")
        
        tableView.tableHeaderView = tableHeaderView
        
        let image = UIImage(named: "Backgroundbg")
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

    @IBAction func btnActionSearch(_ sender: Any) {
    
    }
}

//MARK: UITableView dataSource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if !favouries.isEmpty {count += 1 }
        if !movies.isEmpty { count += 1 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = HomePageSections(rawValue: section) else {
            return 0
        }
        switch sectionType {
        case .favourites:
            return favouries.count > 0 ? 1 : 0
        default:
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else { return nil }
        guard let sectionType = HomePageSections(rawValue: section) else {
            return sectionHeaderView
        }
        sectionHeaderView.configureFor(type: sectionType)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeHeaderView.height
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
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell") as? MovieTableCell else {
                return UITableViewCell()
            }
            cell.setupData(model: self.movies[indexPath.row])
            return cell
        }
    }
    
    
}

extension HomeViewController: HomeViewModelProtocol {
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .getMoviesResponse(let response):
            self.favouries = response ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .getStaffPicksResponse(let response):
            self.movies = response ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
