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
        image = nil

        addSpinner()

        if let task = task {
            task.cancel()
        }

        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
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

    func addSpinner() {
        addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        spinner.startAnimating()
    }

    func removeSpinner() {
        spinner.removeFromSuperview()

    }
}
