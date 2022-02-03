//
//  DUHomeTableViewCellHub.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit
import SDWebImage

// MARK: - DUHomeTableViewCellHubFactory
class DUHomeTableViewCellHubFactory <T: UIView> {
    class func grabFromHub() -> T {
        if let cellArray = Bundle.main.loadNibNamed("DUHomeTableViewCellHub", owner: DUHomeTableViewCellHub(), options: nil) {
            for loadedView in cellArray {
                if let loadedView = loadedView as? T {
                    return loadedView
                }
            }
        }
        
        return T()
    }
}

// MARK: - DUHomeTableViewCellHub
class DUHomeTableViewCellHub: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - DUCarDetailCell
class DUCarDetailCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private weak var carMakeLabel: UILabel!
    @IBOutlet private weak var regNoLabel: UILabel!
    @IBOutlet private weak var transmissionAndFuelTypeLabel: UILabel!
    var radius: CGFloat = 16
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with model: DUCarModel) {
        if let urlString = model.image, let imageURL = URL(string: urlString) {
            carImageView.sd_setImage(with: imageURL, placeholderImage: DUUtilitie.getGalleryPlaceholderImage(), options: [.progressiveLoad])
        }

        carMakeLabel.text = model.make
        regNoLabel.text = model.regNo
        transmissionAndFuelTypeLabel.text = (model.transmission ?? "").capitalized + " - " + (model.fuelType ?? "").capitalized
        configureAppearance()
    }
    
    // MARK: - Private Configuration
    private func configureAppearance() {
        containerView.layer.cornerRadius = radius
        containerView.layer.masksToBounds = true
    }
}

// MARK: - DUCycleGalleryCellDelegate - Common for Region 5 & 6
protocol DUCycleGalleryCellDelegate: NSObjectProtocol {
    func didSelectOffer(with model: DUOfferModel)
}

// MARK: - DUCycleGalleryTableCell
class DUCycleGalleryTableCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var carouselCollectionView: UICollectionView!
    @IBOutlet public weak var heightConstraint: NSLayoutConstraint! // Default 150

    var offerArray: [DUOfferModel] = []
    var doSetupOnces: Bool = false
    var cArray: [CarouselModel] = []
    weak var delegate: DUCycleGalleryCellDelegate?
    
    private var carouselDataSource: InfiniteCollectionViewDataSource<DUOfferCollectionCell, CarouselModel>?
    /*
     Note: R2 UI is similar to R1 so reusing the DUOfferCollectionCell of region 1
     */
    func setupCell(with offerArray: [DUOfferModel], title: String, cellDelegate: DUCycleGalleryCellDelegate) {
        if doSetupOnces == false {
            doSetupOnces = true
            self.offerArray = offerArray
            delegate = cellDelegate
            
            titleLabel.text = title.capitalized
            for model in offerArray {
                let carouselModel = CarouselModel(imageURL: URL(string: model.image ?? DUUtilitie.defaultImgUrl), offerModel: model)
                cArray.append(carouselModel)
            }
            configureCarouselCollectionView()
        }
    }
    
    func configureCarouselCollectionView() {
        carouselCollectionView.showsVerticalScrollIndicator = false
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.backgroundColor = .clear
        carouselCollectionView.decelerationRate = .fast
        carouselCollectionView.collectionViewLayout = LeftedFlowLayout()
        carouselCollectionView.register(DUOfferCollectionCell.self)

        carouselDataSource = InfiniteCollectionViewDataSource(
            data: cArray,
            cellClass: DUOfferCollectionCell.self
        ) { cModel, cell in
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:)))
            cell.imageView.isUserInteractionEnabled = true
            cell.addGestureRecognizer(gesture)
            cell.configure(carouselModel: cModel)
        }
        
        carouselCollectionView.dataSource = carouselDataSource
        DispatchQueue.main.async {
            self.carouselCollectionView.scrollToItem(
                at: IndexPath(item: 500, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    @objc func imageViewTapped(_ gesture: UIGestureRecognizer) {
        var offerModel: DUOfferModel?
        if let cell = gesture.view as? DUOfferCollectionCell, let carouselModel = cell.carouselModel {
            offerModel = carouselModel.offerModel
        }
        
        if let offerModel = offerModel, let delegate = delegate {
            delegate.didSelectOffer(with: offerModel)
        }
    }
}

// MARK: - *****************************************
// MARK: - DU Social Media Cell
// MARK: - *****************************************

// MARK: - DUSocialMediaCellDelegate
protocol DUSocialMediaCellDelegate: NSObjectProtocol {
    func didSelectedRow(with model: DUFeatureModel)
}

// MARK: - DUSocialMediaCell
class DUSocialMediaCell : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: DUSocialMediaCellDelegate?
    var featureModelArray: [DUFeatureModel] = []
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var bottomView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    func setupCell(with featureModelArray: [DUFeatureModel], cellDelegate: DUSocialMediaCellDelegate) {
        self.featureModelArray = featureModelArray
        delegate = cellDelegate
        collectionView.register(UINib(nibName: DUSocialMediaCollectionViewCell.reuseIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: DUSocialMediaCollectionViewCell.reuseIdentifier)
        collectionView.reloadData()
        showExtraView()
        configureAppearance()
    }
    
    func hideTopView() {
        topView.isHidden = true
        bottomView.isHidden = false
    }
    
    func hideBottomView() {
        topView.isHidden = false
        bottomView.isHidden = true
    }
    
    private func showExtraView() {
        topView.isHidden = false
        bottomView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DUSocialMediaCollectionViewCell.reuseIdentifier, for: indexPath) as! DUSocialMediaCollectionViewCell
        let model = featureModelArray[indexPath.row]
        
        cell.titleLabel.text = model.screenName
        if let imageURL: String = model.imageURL, let urlString = imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let link = URL(string: urlString)
            cell.imageView.sd_setImage(with: link, placeholderImage: DUUtilitie.getGalleryPlaceholderImage(), options: [.progressiveLoad])
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let delegate = delegate {
            let rowModel = featureModelArray[indexPath.row]
            delegate.didSelectedRow(with: rowModel)
        }
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DUUtilitie.getSocialMediaCellWidth(), height: 99)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Private Configuration
    func configureAppearance() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
}

// MARK: - DUHeaderTitleCell
class DUHeaderTitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
 
    func setupCell(with title: String) {
        titleLabel.text = title
    }
}
