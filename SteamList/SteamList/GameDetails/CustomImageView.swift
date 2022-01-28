//
//  CustomImageView.swift
//  SteamList
//
//  Created by Adam Bokun on 16.12.21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.image = nil
            }
            self.addSpinner()
            
            if let task = self.task {
                task.cancel()
            }
            
            if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.image = imageFromCache
                }
                self.removeSpinner()
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                
                guard
                    let data = data,
                    let newImage = UIImage(data: data)
                else {
                    print("couldn't load image from url: \(url)")
                    return
                }
                
                imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = newImage
                    self.removeSpinner()
                }
            }
            
            task.resume()
        }
    }
    
    func addSpinner() {
        DispatchQueue.main.async {
            self.addSubview(self.spinner)
            self.spinner.translatesAutoresizingMaskIntoConstraints = false
            self.spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            self.spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.spinner.startAnimating()
            
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinner.removeFromSuperview()
        }
    }
}
