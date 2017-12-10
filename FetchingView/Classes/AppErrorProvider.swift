//
//  AppErrorProvider.swift
//  FetchingView
//
//  Created by Neil Jain on 03/12/17.
//

import UIKit

public protocol AppErrorProvider: Error {
    var title: String { get }
    var subtitle: String? { get }
    var image: UIImage? { get }
}
