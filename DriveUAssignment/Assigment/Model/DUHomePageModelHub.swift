//
//  
//  DUHomePageModelHub.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//
//
import Foundation

// MARK: - DUHomePageModel
struct DUHomePageModel: Codable {
    var status: String?
    var feeds: [DUFeedModel] = []
    var greetingMessage: String?
}

// MARK: - DUFeedModelType
enum DUFeedModelType: String {
    case car = "carDetails"
    case feature = "Social Apps"
    case offers = "offers"
    case unknown = ""
}

// MARK: - DUFeedModel
struct DUFeedModel: Codable {
    var car: DUCarModel?
    var screen: String = ""
    var features: [DUFeatureModel]?
    var offers: [DUOfferModel]?
    
    func getFeedModelType() -> DUFeedModelType {
        if screen.lowercased() == DUFeedModelType.car.rawValue.lowercased() && car != nil {
            return .car
        } else if screen.lowercased() == DUFeedModelType.feature.rawValue.lowercased(), features != nil {
            return .feature
        } else if screen.lowercased() == DUFeedModelType.offers.rawValue.lowercased(), offers != nil {
            return .offers
        } else {
            return .unknown
        }
    }
}

// MARK: - DUCarModel
struct DUCarModel: Codable {
    var image: String?
    var regNo, fuelType, transmission, model: String?
    var carID: Int?
    var make: String?

    enum CodingKeys: String, CodingKey {
        case image, regNo, fuelType, transmission, model
        case carID = "car_id"
        case make
    }
}

// MARK: - DUFeatureModel
struct DUFeatureModel: Codable {
    var imageURL: String?
    var screenName: String?
    var redirectURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case screenName
        case redirectURL = "redirectUrl"
    }
}

// MARK: - DUOfferModel
struct DUOfferModel: Codable {
    var image: String?
    var screenName, name: String?

    enum CodingKeys: String, CodingKey {
        case image
        case screenName = "screen_name"
        case name
    }
}
