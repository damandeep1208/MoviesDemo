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
    var overview: String?
    var reviews: Int?
    var genres: [String]?
    var budget: Double?
    var revenue: Double?
    var language: String?
    var cast: [User]?
    var director: User?
    var runtime: Int?
}

extension Dictionary where Key == String {
    
    func toMovieModel() -> Movie {
        let model = Movie()
        model.id = self["id"] as? Int
        model.posterUrl = self["posterUrl"] as? String
        model.title = self["title"] as? String
        model.releaseDate = self["releaseDate"] as? String
        model.rating = self["rating"] as? Double
        model.overview = self["overview"] as? String
        model.reviews = self["reviews"] as? Int
        model.budget = self["budget"] as? Double
        model.revenue = self["revenue"] as? Double
        model.language = self["language"] as? String
        model.genres = self["genres"] as? [String]
        model.runtime =  self["runtime"] as? Int
        model.director = (self["director"] as? [String: Any])?.toUserModel()
        model.cast = (self["cast"] as? [[String: Any]])?.map({ $0.toUserModel() })
        return model
    }
    
    func toUserModel() -> User {
        let model = User()
        model.name = self["name"] as? String
        model.pictureUrl = self["pictureUrl"] as? String
        model.character = self["character"] as? String
        return model
    }
}

class User {
    var name: String?
    var pictureUrl: String?
    var character: String?
}
