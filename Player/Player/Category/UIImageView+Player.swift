//
//  UIImageView+Player.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageFromURL(url: String?) {
        self.image = UIImage(named: "AppIcon")
        guard let safeUrlString = url, let safeUrl = URL(string: safeUrlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: safeUrl) { (data, response, error) in
            if error != nil {
                log.error("Failed fetching image: \(error.debugDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                log.error("Error with HTTPURLResponse or statusCode")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
}
