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
        
        /*
        do {
            if let url = URL(string: urlString) {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }
        catch{
            print(error)
        }
        */
        /*
        do {
            if let thumbnail_id = result.thumbnail_id,
               let http = URL(string: "https://http2.mlstatic.com/D_NQ_NP_" + thumbnail_id + "-R.jpg"),
               var comps = URLComponents(url: http, resolvingAgainstBaseURL: false) {
                comps.scheme = "https"
                let https = comps.url!
                let data = try Data(contentsOf: https)
                cell.imageItem.image = UIImage(data: data)
            }
        }
        catch{
            print(error)
        }
 */
        
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
