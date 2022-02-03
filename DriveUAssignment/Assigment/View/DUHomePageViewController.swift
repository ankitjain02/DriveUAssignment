//
//  
//  DUHomePageViewController.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//
//
import UIKit

class DUHomePageViewController: UIViewController {
    // Add here outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Add here your view model
    lazy var viewModel: DUHomePageViewModel = {
        return DUHomePageViewModel(withDelegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() {
        // Add here the setup for the UI
        
    }
    
    func initViewModel() {
        // Fetch Data
        viewModel.fetchData()
    }
}

// MARK: - DUHomePageDelegate
extension DUHomePageViewController: DUHomePageDelegate {
    func homePageServiceResponse(with status: ServiceStatus) {
        if status == .success {
            title = viewModel.getGreetingMessage()
            tableView.reloadData()
        } else {
            let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            AlertUtility.singleton.showAlert(withTitle: "Error", message: "Service call failed, please try again.", actions: [okAction], viewController: self)
        }
    }
}

// MARK: - UITableViewDataSource
extension DUHomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let feedModel = viewModel.getFeed(forSection: indexPath.section) else {
            return UITableView.automaticDimension
        }
        
        if feedModel.getFeedModelType() == .feature {
            return 123
        } 
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let feedModel = viewModel.getFeed(forSection: section) else {
            return UIView(frame: .zero)
        }
        
        if feedModel.getFeedModelType() == .feature {
            let headerView = DUHomeTableViewCellHubFactory<DUHeaderTitleCell>.grabFromHub()
            headerView.setupCell(with: feedModel.screen)
            return headerView
        }
        
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let feedModel = viewModel.getFeed(forSection: section) else {
            return 1
        }
        
        if feedModel.getFeedModelType() == .feature {
            return 52
        } else if feedModel.getFeedModelType() == .car && section != 0 {
            return 12
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let feedModel = viewModel.getFeed(forSection: section) else {
            return nil
        }
        
        if feedModel.getFeedModelType() == .feature {
            return feedModel.screen
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feedModel = viewModel.getFeed(forSection: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch feedModel.getFeedModelType() {
        case .car:
            return getDUCarDetailCell(with: tableView, feedModel: feedModel)
        case .feature:
            return getDUSocialMediaCell(with: tableView, feedModel: feedModel, indexPath: indexPath)
        case .offers:
            return getDUCycleGalleryTableCell(with: tableView, feedModel: feedModel)
        case .unknown:
            return UITableViewCell()
        }
    }
    
    func getDUCarDetailCell(with tableView: UITableView, feedModel: DUFeedModel) -> DUCarDetailCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: DUCarDetailCell.reuseIdentifier) as? DUCarDetailCell
        
        if nullableCell == nil {
            nullableCell = DUHomeTableViewCellHubFactory<DUCarDetailCell>.grabFromHub()
        }
        
        guard let cell = nullableCell else {
            assert(true)
            return DUCarDetailCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        // Setup Cell
        if let carModel = feedModel.car {
            cell.setupCell(with: carModel)
        }
        
        return cell
    }
    
    func getDUCycleGalleryTableCell(with tableView: UITableView, feedModel: DUFeedModel) -> DUCycleGalleryTableCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: DUCycleGalleryTableCell.reuseIdentifier) as? DUCycleGalleryTableCell
        if nullableCell == nil {
            nullableCell = DUHomeTableViewCellHubFactory<DUCycleGalleryTableCell>.grabFromHub()
        }
        
        guard let cell = nullableCell, let offerArray = feedModel.offers else {
            assert(true)
            return DUCycleGalleryTableCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        cell.setupCell(with: offerArray, title: feedModel.screen, cellDelegate: self)
        
        return cell
    }
    
    func getDUSocialMediaCell(with tableView: UITableView, feedModel: DUFeedModel, indexPath: IndexPath) -> DUSocialMediaCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: DUSocialMediaCell.reuseIdentifier) as? DUSocialMediaCell
        if nullableCell == nil {
            nullableCell = DUHomeTableViewCellHubFactory<DUSocialMediaCell>.grabFromHub()
        }
        
        guard let cell = nullableCell else {
            assert(true)
            return DUSocialMediaCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        cell.setupCell(with: viewModel.getFeatureArray(forSection: indexPath.section)[indexPath.row], cellDelegate: self)
        
        if indexPath.row == 0 {
            cell.hideTopView()
        } else if indexPath.row == viewModel.getFeatureArray(forSection: indexPath.section).count - 1 {
            cell.hideBottomView()
        }
        
        return cell
    }
}

// MARK: - DUCycleGalleryCellDelegate
extension DUHomePageViewController: DUCycleGalleryCellDelegate {
    func didSelectOffer(with model: DUOfferModel) {
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        AlertUtility.singleton.showAlert(withTitle: model.name, message: nil, actions: [okAction], viewController: self)
    }
}

// MARK: - DUSocialMediaCellDelegate
extension DUHomePageViewController: DUSocialMediaCellDelegate {
    func didSelectedRow(with model: DUFeatureModel) {
        
        if let navigationController = navigationController {
            let webController = DUWebViewController()
            webController.viewModel.featureModel = model
            webController.title = model.screenName
            navigationController.pushViewController(webController, animated: true)
        }
    }
}
