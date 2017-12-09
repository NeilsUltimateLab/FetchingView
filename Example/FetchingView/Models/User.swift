//
//  User.swift
//  FetchingView_Example
//
//  Created by Neil Jain on 09/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    var name: String?
}

extension User {
    static func resource(completion: @escaping (Result<[User]>)->Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let webResource = WebResource<[User]>(url: url)
        WebResourceManager.shared.fetchResource(resource: webResource, completion: completion)
    }
}
