//
//  DataStorage.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/26/22.
//

import Foundation

class DataStorage {
    
    enum DataStorageKey: String {
        case bookmarkedItems = "bookmarkedItems"
    }
    
    static func addToBookMark(movieId: Int) {
        var bookMarkedMovies = UserDefaults.standard.value(forKey: DataStorageKey.bookmarkedItems.rawValue) as? [Int] ?? []
        if !bookMarkedMovies.contains(movieId) {
            bookMarkedMovies.append(movieId)
        }
        UserDefaults.standard.setValue(bookMarkedMovies, forKey: DataStorageKey.bookmarkedItems.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeFromBookMark(movieId: Int) {
        var bookMarkedMovies = UserDefaults.standard.value(forKey: DataStorageKey.bookmarkedItems.rawValue) as? [Int] ?? []
        if let index = bookMarkedMovies.firstIndex(of: movieId) {
            bookMarkedMovies.remove(at: index)
        }
        UserDefaults.standard.setValue(bookMarkedMovies, forKey: DataStorageKey.bookmarkedItems.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func isBookMarked(movieId: Int) -> Bool {
        let bookMarkedMovies = UserDefaults.standard.value(forKey: DataStorageKey.bookmarkedItems.rawValue) as? [Int] ?? []
        if bookMarkedMovies.contains(movieId) {
            return true
        }
        return false
    }
    
    static func bookmarkedItems() -> [Int] {
        return UserDefaults.standard.value(forKey: DataStorageKey.bookmarkedItems.rawValue) as? [Int] ?? []
    }
}
