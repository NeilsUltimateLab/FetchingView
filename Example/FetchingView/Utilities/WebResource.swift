//
//  WebResource.swift
//  Codablabity
//
//  Created by Neil Jain on 07/12/17.
//  Copyright © 2017 Neil Jain. All rights reserved.
//

import Foundation

struct WebResource<A: Codable> {
    var url: URL
}

extension WebResource {
    func decode(_ data: Data) -> Result<A> {
        do {
            let decode = JSONDecoder()
            let value = try decode.decode(A.self, from: data)
            return Result.value(value)
        } catch let error {
            return Result.error(AppError.serverError(error))
        }
    }
}
