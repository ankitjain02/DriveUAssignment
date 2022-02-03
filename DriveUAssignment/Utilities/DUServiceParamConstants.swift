//
//  DUServiceParamConstants.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import Foundation

// MARK: - HTTPMethodType
enum HTTPMethodType: Int {
    case unknown
    case get
    case post
    case delete
    case put
}

// MARK: - HTTPMethodConstants
struct HTTPMethodConstants {
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
    static let PUT = "PUT"
}
