//
//  HomeViewModel.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/26/22.
//

import Foundation

protocol HomeViewModelProtocol {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
}

enum HomeViewModelOutput {
    case getMoviesResponse([Movie]?)
    case getStaffPicksResponse([Movie]?)
}

class HomeViewModel {
    
    var delegate:HomeViewModelProtocol?
    
    func getMovies() {
        FetchDataService.fetchData(url: "https://apps.agentur-loop.com/challenge/movies.json") { (response, error) in
            let arrModel = response?.map({$0.toMovieModel()})
            self.notify(.getMoviesResponse(arrModel))
        }
    }
    
    func getStaffPicks() {
        FetchDataService.fetchData(url: "https://apps.agentur-loop.com/challenge/staff_picks.json") { (response, error) in
            let arrModel = response?.map({$0.toMovieModel()})
            self.notify(.getStaffPicksResponse(arrModel))
        }
    }
    
    //MARK: call delegates in view controller to handle HomeViewModelOutput
    private func notify(_ output: HomeViewModelOutput  ) {
        delegate?.handleViewModelOutput(output)
    }
}
