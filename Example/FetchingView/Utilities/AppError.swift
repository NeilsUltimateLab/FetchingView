//
//  AppError.swift
//  FetchingView_Example
//
//  Created by Neil Jain on 03/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import FetchingView

enum AppError: Error {
    
    /// In case of token expired from server.
    ///
    /// Will show in-screen message or alert.
    ///
    /// For this case the `HTTPResponse` code is `401`.
    ///
    /// Must login again.
    case sessionExpired
    
    /// In case of server is bussy or server's internal error
    case serverError(Error)
    
    /// In case of wrong `URL` or server might not exist
    case notFound
    
    /// In case of web server response is not parsed
    ///
    /// May be change in parameters.
    case canNotParse
    
    /// In case of No Internet connection.
    ///
    /// Will show in-screen message or alert.
    case notReachable
    
    /// In case of longer response time.
    case requestTimedOut
}

extension AppError: AppErrorProvider {
    var title: String {
        switch self {
        case .notFound, .canNotParse:
            return "Oops"
        case .notReachable:
            return "Ohh"
        case .requestTimedOut:
            return "Ahhh..."
        case .sessionExpired:
            return "Hey"
        case .serverError(_):
            return "Oops"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .notFound:
            return "Path not found"
        case .notReachable:
            return "We have lost connection. Please try again later!"
        case .requestTimedOut:
            return "Please try again in a while"
        case .sessionExpired:
            return "Your session is expired. Please login again to continue"
        case .serverError(_):
            return "Something went wrong"
        case .canNotParse:
            return "Something went wrong"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .notFound:
            return nil
        case .notReachable:
            return #imageLiteral(resourceName: "QuestionFace")
        case .requestTimedOut:
            return #imageLiteral(resourceName: "QuestionFace")
        case .sessionExpired:
            return #imageLiteral(resourceName: "QuestionFace")
        case .serverError(_):
            return nil
        case .canNotParse:
            return nil
        }
    }
    
    var retryButtonTitles: [String]? {
        switch self {
        case .notFound:
            return nil
        case .notReachable:
            return nil //["Retry"]
        case .requestTimedOut:
            return nil // ["Retry"]
        case .sessionExpired:
            return nil //["Login"]
        case .serverError(_):
            return nil
        case .canNotParse:
            return nil
        }
    }
    
    
}
