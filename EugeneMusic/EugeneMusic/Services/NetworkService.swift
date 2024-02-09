//
//  NetworkService.swift
//  EugeneMusic
//
//  Created by Eugene on 08/02/2024.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametres = ["term" : "\(searchText)",
                          "limit" : "10",
                          "media": "music"]
        AF.request(url, method: .get, parameters: parametres, headers: nil).responseData { dataResponse in
            if let error = dataResponse.error {
                print("Error \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                completion(objects)
            } catch _ {
                print("Fail to decode")
                completion(nil)
            }
        }
    }
}
