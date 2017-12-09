//
//  Post.swift
//  Codablabity
//
//  Created by Neil Jain on 07/12/17.
//  Copyright © 2017 Neil Jain. All rights reserved.
//

import Foundation

struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

extension Post {
    
    static func resource(completion: @escaping (Result<[Post]>)->Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let webResource = WebResource<[Post]>(url: url)
        WebResourceManager.shared.fetchResource(resource: webResource, completion: completion)
    }
}
