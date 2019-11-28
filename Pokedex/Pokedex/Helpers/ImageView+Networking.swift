//
//  ImageView+Networking.swift
//  Pokedex
//
//  Created by Angel Buenrostro on 11/28/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {
        
        let url = URL(string: urlString)
        
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            
            self.image = cachedImage
            
            return
            
        }

        // if not found in cache, download
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
                return
                
            }

            DispatchQueue.main.async { [weak self] in // Specify weak self to prevent memory leak
                
                if let image = UIImage(data: data!) {
                    
                    imageCache.setObject(image, forKey: urlString as NSString)
                    
                    self?.image = image
                    
                }
            }

        }).resume()
    }
}
