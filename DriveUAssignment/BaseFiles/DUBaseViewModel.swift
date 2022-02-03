//
//  DUBaseViewModel.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit

// MARK: - Defining parsed tuple type alias
typealias ResponseParsedDict = (parsedDict: [String: Any]?, statusCode: Int)

// MARK: - DataBindingFactory
class DataBindingFactory <T: Codable> {
    class func bindData(with data: [String: Any]) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
            if let detail = try? JSONDecoder().decode(T.self, from: jsonData) {
                return detail
            }
        }
        
        return nil
    }
}

// MARK: - DUBaseViewModel
class DUBaseViewModel {
    // MARK: - Common Parsing Logic
    func getParsedSuccessDict(with data: Data?) -> ResponseParsedDict {
        // Convert server json response to NSDictionary
        do {
            if let data = data, let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(convertedJsonIntoDict)
                if "success" == convertedJsonIntoDict["status"] as? String {
                    return (convertedJsonIntoDict, 500)
                } else {
                    return (nil, 500)
                }
            }
        } catch _ as NSError {
            print("** Error parsing response **")
        }
        
        return (nil, 500)
    }
}
