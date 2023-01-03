//
//  ImageLoader.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI

class ImageLoader: ObservableObject {
    let url: String?
    
    @Published var image: UIImage? = nil
    @Published var erroerMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init(url: String) {
        self.url = url
    }
    
    func fetch() {
        
        guard image == nil && !isLoading else {
            erroerMessage = "bad url"
            return
        }
        
        guard let url = url, let fetchURL = URL(string: url) else {
            erroerMessage = "bad url"
            return
        }
        
        isLoading = true
        erroerMessage = nil
        
        let request = URLRequest(url: fetchURL, cachePolicy: .returnCacheDataElseLoad)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self](data, response, error) in
            DispatchQueue.main.async {
                
                self?.isLoading = false
                
                if let error = error {
                    self?.erroerMessage = error.localizedDescription
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    self?.erroerMessage = "API error badResponse"
                } else if let data = data, let image = UIImage(data: data) {
                    self?.image = image
                } else {
                    self?.erroerMessage = "API error unknown"
                }
            }
        }
        task.resume()
    }
}
