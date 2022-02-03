//
//  DUSocialMediaCollectionViewCell.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit

class DUSocialMediaCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var radius: CGFloat = 10
    var featureModel: DUFeatureModel?
    
    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    // MARK: - Configuration

    func configure(featureModel: DUFeatureModel) {
        self.featureModel = featureModel
        
        titleLabel.text = featureModel.screenName
        
        let imageURL = URL(string: featureModel.imageURL ?? DUUtilitie.defaultImgUrl)

        imageView.sd_setImage(with: imageURL, placeholderImage: DUUtilitie.getGalleryPlaceholderImage(), options: [.progressiveLoad]) { (image, error, type, url) in
            
        }
        imageView.contentMode = .scaleAspectFit
        configureAppearance()
    }

    // MARK: - Private Configuration
    func configureAppearance() {
        containerView.layer.cornerRadius = radius
        containerView.layer.masksToBounds = true
    }
}
