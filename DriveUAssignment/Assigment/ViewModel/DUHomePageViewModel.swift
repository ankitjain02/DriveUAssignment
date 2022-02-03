//
//  
//  DUHomePageViewModel.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//
//
import Foundation

// MARK:- ServiceStatus
enum ServiceStatus {
    case success
    case error
}

// MARK:- DUHomePageDelegate
protocol DUHomePageDelegate: NSObjectProtocol {
    func homePageServiceResponse(with status: ServiceStatus)
}

// MARK:-
class DUHomePageViewModel: DUBaseViewModel {
    // Variables
    private lazy var serviceBuilder = DUServiceBuilder()
    private var homePageModel: DUHomePageModel?
    weak var homePageDelegate: DUHomePageDelegate?
    
    // MARK:- Initialize
    
    override init() {
        super.init()
    }
    
    required init(withDelegate delegate: DUHomePageDelegate) {
        super.init()
        homePageDelegate = delegate
    }
    
    // MARK: - Fetching functions
    
    func fetchData() {
        // Show Loader
        DUSpinner.singleton.showIndicator()
        
        serviceBuilder.invokeHomePageService { data, response, error in
            // Hide Loader
            DUSpinner.singleton.hideIndicator()
            
            DispatchQueue.main.async {
                if let parsedDict = self.getParsedSuccessDict(with: data).parsedDict {
                    self.loadData(with: parsedDict)
                } else {
                    self.postServiceFailure()
                }
            }
        }
    }
    
    private func loadData(with data: [String: Any]) {
        if let model = DataBindingFactory<DUHomePageModel>.bindData(with: data) {
            homePageModel = model
        } else {
            postServiceFailure()
        }
        
        if let delegate = homePageDelegate {
            delegate.homePageServiceResponse(with: .success)
        }
    }
    
    private func postServiceFailure() {
        if let delegate = self.homePageDelegate {
            delegate.homePageServiceResponse(with: .error)
        }
    }
    
    func numberOfSections() -> Int {
        guard let homePageModel = homePageModel else { return 0 }
        return homePageModel.feeds.count
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let homePageModel = homePageModel else { return 0 }
        if homePageModel.feeds.indices.contains(section) {
            switch homePageModel.feeds[section].getFeedModelType() {
            case .car:
                return 1
            case .feature:
                return getFeatureArray(forSection: section).count
            case .offers:
                return 1
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func getGreetingMessage() -> String {
        guard  let homePageModel = homePageModel, let greetingMessage = homePageModel.greetingMessage else {
            return "Welcome"
        }
        
        return greetingMessage
    }
    
    func getFeed(forSection section: Int) -> DUFeedModel? {
        guard  let homePageModel = homePageModel else {
            return nil
        }
        return homePageModel.feeds[section]
    }
    
    func getFeatureArray(forSection section: Int) -> [[DUFeatureModel]] {
        guard  let homePageModel = homePageModel, let featuresArray = homePageModel.feeds[section].features else {
            return []
        }
        
        // Break the response into chunk of 4
        let chuckedArray = featuresArray.chunked(into: Int(DUUtilitie.getNumberOfIcon()))
        return chuckedArray
    }
}
