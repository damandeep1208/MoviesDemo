//
//  FetchDataService.swift
//  MoviesDemo
//
//  Created by Damandeep Kaur on 10/26/22.
//

import Foundation

class FetchDataService {
    static func fetchData(url: String, completion: @escaping ([[String:Any]]?, Error?) -> Void) {
        let url = URL(string: url)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
