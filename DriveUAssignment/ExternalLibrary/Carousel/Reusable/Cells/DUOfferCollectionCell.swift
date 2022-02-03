//
//  DiscountCell.swift
//  Carousel
//
//  Created by Alexey Zhulikov on 15.10.2019.
//  Copyright © 2019 Alexey Zhulikov. All rights reserved.
//

import UIKit

final class DUOfferCollectionCell: UICollectionViewCell {

    // MARK: - Subviews

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var radius: CGFloat = 10
    var carouselModel: CarouselModel?
    
    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    // MARK: - Configuration

    func configure(carouselModel: CarouselModel) {
        self.carouselModel = carouselModel
        imageView.sd_setImage(with: carouselModel.imageURL, placeholderImage: DUUtilitie.getGalleryPlaceholderImage(), options: [.progressiveLoad]) { (image, error, type, url) in
            
        }
        configureAppearance()
    }

    // MARK: - Private Configuration
    func configureAppearance() {
        containerView.layer.cornerRadius = radius
        containerView.layer.masksToBounds = true
    }

}
