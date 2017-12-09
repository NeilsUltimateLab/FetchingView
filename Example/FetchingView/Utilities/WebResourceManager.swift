//
//  WebResourceManager.swift
//  Codablabity
//
//  Created by Neil Jain on 07/12/17.
//  Copyright © 2017 Neil Jain. All rights reserved.
//

import Foundation
import FetchingView

enum Result<A> {
    case error(AppErrorProvider)
    case value(A)
}

extension Result {
    var error: AppErrorProvider? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    
    var value: A? {
        switch self {
        case .value(let value):
            return value
        default:
            return nil
        }
    }
}

class WebResourceManager: NSObject {
    static let shared: WebResourceManager = WebResourceManager()
    
    func fetchResource<A>(resource: WebResource<A>, completion: @escaping (Result<A>)->Void) {
        DispatchQueue.global().async {
            let session = URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
                DispatchQueue.main.async {
                    completion(resource.decode(data!))
                }
            }
            session.resume()
        }
        
    }
    
}
