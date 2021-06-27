//
//  UIImageViewFromURL.swift
//  TestML
//
//  Created by Tomas on 22/06/2021.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

class UIImageViewFromURL : UIImageView {
    var imageURL = ""
    
    func load(urlString : String) {
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async { [ weak self ] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if self?.imageURL == urlString {
                            imageCache.setObject(image, forKey: urlString as NSString)
                            self?.image = image
                        }
                    }
                }
            }
        }
 
    }
}
