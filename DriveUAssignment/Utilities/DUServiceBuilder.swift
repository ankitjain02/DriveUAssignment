//
//  DUServiceBuilder.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit

class ServiceData: NSObject {
    var httpMethodType: HTTPMethodType = .unknown
    var urlWithParams: String = ""
    var headerFields: [(value: String, HTTPHeaderField: String)]?
    var httpBody: Data? // Optional will be used in case of create
    
    override init() {
        super.init()
    }
    
    init(with type: HTTPMethodType, params: String) {
        super.init()
        httpMethodType = type
        urlWithParams = params
    }
}

// MARK: - DUServiceBuilder
struct DUServiceBuilder {
    // MARK: - Common Service call
    private func invokeService(with params: [String: String], scriptUrl: String, type: HTTPMethodType, httpBody: Data? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var urlWithParams = scriptUrl
        for (_, queryDict) in params.enumerated() {
            if let term = queryDict.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                urlWithParams = urlWithParams + "&\(queryDict.key)=\(term)"
            }
        }
                
        // Create Service Data & Invoke data task
        let serviceData = ServiceData(with: type, params: urlWithParams)
        serviceData.httpBody = httpBody
        invokeDataTask(with: serviceData, completionHandler: completionHandler)
    }
    
    // Common Data Task Function
    private func invokeDataTask(with serviceData: ServiceData, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // Create NSURL Object
        guard let serviceUrl = NSURL(string: serviceData.urlWithParams) else { return }
        print(serviceData.urlWithParams)
        print(serviceUrl.absoluteString!)
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:serviceUrl as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = getHttpMethod(for: serviceData.httpMethodType)
        
        // Setup the header parameters
        if let headerFields = serviceData.headerFields?.enumerated() {
            for (_, httpHeaderPair) in headerFields {
                request.addValue(httpHeaderPair.value, forHTTPHeaderField: httpHeaderPair.HTTPHeaderField)
            }
        }
    
        // Set HTTPBody
        if let body = serviceData.httpBody {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        print("** SERVICE CALL :: Type = \(request.httpMethod) & URL = \(String(describing: request.url)) **")
        
        //  request.addValue(, forHTTPHeaderField: )
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // Convert server json response to NSDictionary
            do {
                if let data = data, let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("********** Service Response Success **********\n")
                    DispatchQueue.main.async {
                        if let code = convertedJsonIntoDict["code"] {
                            print("** CODE :: \(code) **\n")
                        }
                        print("Service Response :: \n \(convertedJsonIntoDict)")
                    }
                    
                }
            } catch _ as NSError {
                print("********** Service Response Failure **********\n")
                print("** Error in Service Call **")
            }
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    
    private func getHttpMethod(for type: HTTPMethodType) -> String {
        switch type {
        case .get:
            return HTTPMethodConstants.GET
        case .post:
            return HTTPMethodConstants.POST
        case .delete:
            return HTTPMethodConstants.DELETE
        case .put:
            return HTTPMethodConstants.PUT
        default:
            return ""
        }
    }
    
    // MARK: - API Call Methods - Home Page
    func invokeHomePageService(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        invokeService(with: [:], scriptUrl: getHomeViewURL(), type: .get, httpBody: nil, completionHandler: completionHandler)
    }
}

// MARK: - URL Methods
extension DUServiceBuilder {
    // URL Methods
    func getHomeViewURL() -> String {
        return "https://jsonkeeper.com/b/TMAP"
    }
}
