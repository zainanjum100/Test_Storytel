//
//  File.swift
//  
//
//  Created by Zain Ul Abideen on 09/09/2020.
//

import Foundation
public typealias Completion<T> = (Result<T,Error>) -> ()

public enum HTTPMethod: String{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case update = "UPDATE"
}
public extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
enum ServiceError: Error {
    case custom(String)
    case noInternetAvailable
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInternetAvailable:
            return NSLocalizedString("Internet seems to be offline", comment: "")
        case .custom(let error):
            return error
        }
    }
}
