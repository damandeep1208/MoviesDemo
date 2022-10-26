//
//  Movie.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/26/22.
//

import Foundation

class Movie {
    var id: Int?
    var posterUrl: String?
    var title: String?
    var releaseDate: String?
    var rating: Double?
}

extension Dictionary where Key == String {
    
    func toMovieModel() -> Movie {
        let model = Movie()
        model.id = self["id"] as? Int
        model.posterUrl = self["posterUrl"] as? String
        model.title = self["title"] as? String
        model.releaseDate = self["releaseDate"] as? String
        model.rating = self["rating"] as? Double
        return model
    }
}
