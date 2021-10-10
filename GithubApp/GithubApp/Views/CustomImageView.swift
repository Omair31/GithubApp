//
//  CustomImageView.swift
//  GithubApp
//
//  Created by VenD-Omeir on 09/10/2021.
//

import UIKit
var cache = [String:UIImage]()

class CustomImageView: UIImageView {
    var previousUrl:String?
    func loadImageWithUrlString(url:String) {
        previousUrl = url
        self.image = nil
        guard let url = URL(string: url) else {return}
        
        if let image = cache[url.absoluteString] {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if url.absoluteString != self.previousUrl {
                return
            }
            
            guard let data = data else {return}
            let image = UIImage(data: data)
            cache[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
