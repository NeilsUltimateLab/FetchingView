//
//  FetchingState.swift
//  FetchingView
//
//  Created by Neil Jain on 03/12/17.
//

import Foundation

public enum FetchingState<A> {
    case fetching
    case fetchedError(AppErrorProvider)
    case fetchedData(A)
}
