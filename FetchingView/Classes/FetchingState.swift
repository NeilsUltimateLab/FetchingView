//
//  FetchingState.swift
//  FetchingView
//
//  Created by Neil Jain on 03/12/17.
//

import Foundation


/// State maching to track Web-request states.
///
/// - fetching: `.fetching` should be set before the web-request call
/// - fetchedError: `.fetchedError(AppErrorProvider)` should be set when returned `Error` from the web-request
/// - fetchedData: `.fetchedData(A)` should be set when returned the `object` successfully.
public enum FetchingState<A> {
    case fetching
    case fetchedError(AppErrorProvider)
    case fetchedData(A)
}
