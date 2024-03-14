//
//  ProductCell.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productBackgroundView: UIView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var product: Product? {
        didSet { // Property Observer
            productDetailConfiguration()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        productBackgroundView.clipsToBounds = false
        productBackgroundView.layer.cornerRadius = 15

        productImageView.layer.cornerRadius = 10

        self.productBackgroundView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func productDetailConfiguration() {
        guard let product else { return }
        productTitleLabel.text = product.title
        productCategoryLabel.text = product.category
        descriptionLabel.text = product.description
        priceLabel.text = "$\(product.price)"
        rateButton.setTitle("\(product.rating.rate)", for: .normal)
        if let imageURL = product.image {
            ImageLoader.loadImage(from: imageURL) { image in
                if let image = image {
                    self.productImageView.image = image
                } else {
                    // Handle failure to load image
                    self.productImageView.image = UIImage(named: "Product")
                }
            }
        }
    }
    
}
