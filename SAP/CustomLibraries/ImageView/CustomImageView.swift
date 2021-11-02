//
//  CustomImageView.swift
//  SAP
//
//  Created by byndr on 02/11/21.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {

    // MARK: - Constants

    let imageCache = NSCache<NSString, AnyObject>()

    // MARK: - Properties

    var imageURLString: String?

    func downloadImageFrom(urlString: String, imageMode: UIView.ContentMode = .scaleAspectFit, completion:@escaping (UIImage?) -> Void = nil) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, imageMode: imageMode, completion: completion)
    }

    func downloadImageFrom(url: URL, imageMode: UIView.ContentMode  = .scaleAspectFit, completion:@escaping (UIImage?) -> Void = nil) {
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self?.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self?.image = imageToCache
                    completion(imageToCache)
                }
            }.resume()
        }
    }
}
