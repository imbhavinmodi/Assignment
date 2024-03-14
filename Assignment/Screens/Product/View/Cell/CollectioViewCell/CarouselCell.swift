//
//  CarouselCell.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    var product: Product? {
        didSet { // Property Observer
            productDetailConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        
    }

    func productDetailConfiguration() {
        guard let product else { return }
        
        if let imageURL = product.image {
            ImageLoader.loadImage(from: imageURL) { image in
                if let image = image {
                    self.image.image = image
                } else {
                    // Handle failure to load image
                    self.image.image = UIImage(named: "MovieDetails")
                }
            }
        }
    }
}
