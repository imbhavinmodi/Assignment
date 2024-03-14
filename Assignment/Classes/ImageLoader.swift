//
//  ImageLoader.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import UIKit

class ImageLoader {
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Failed to convert data to image")
                    completion(nil)
                }
            }
        }.resume()
    }
}
