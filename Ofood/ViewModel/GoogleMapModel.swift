//
//  GoogleMapModel.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI
import CoreLocation

class GoogleMapModel {
    let api_Key = "AIzaSyB_6IaMHX5qubhPXhwpD9QOUq4B5NBlQTE"
    
    func fetchNearLocation(_ location: String, keyWord: String, completion: @escaping (Result<[Results],Error>) -> Void) {
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=2000&keyword=\(keyWord)&language=zh-TW&key=\(api_Key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        print(decoder)
                        let GoogleMapResponse = try decoder.decode(GoogleMapResponse.self, from: data)
                        completion(.success(GoogleMapResponse.results))
                    }catch{
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}


struct GoogleMapResponse: Codable {
    let results: [Results]
}

struct Results: Codable {
    let name: String
    let vicinity: String
}
