# FetchingView

[![CI Status](http://img.shields.io/travis/NeilsUltimateLab/FetchingView.svg?style=flat)](https://travis-ci.org/NeilsUltimateLab/FetchingView)
[![Version](https://img.shields.io/cocoapods/v/FetchingView.svg?style=flat)](http://cocoapods.org/pods/FetchingView)
[![License](https://img.shields.io/cocoapods/l/FetchingView.svg?style=flat)](http://cocoapods.org/pods/FetchingView)
[![Platform](https://img.shields.io/cocoapods/p/FetchingView.svg?style=flat)](http://cocoapods.org/pods/FetchingView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Fetching view has a state machine called Fetching State :
```
enum FetchingState<A> {
    case fetching
    case fetchedError(AppErrorProvider)
    case fetchedData(A)
}
```

Fetching view will display `UIActivityIndicatorView` for `FetchingState<A>.fetching` and error message for `.fetchedError(Error)` state.

#####Here is an screenshot from an example application using FetchingView

![Screenshot of Example application](FetchingView/FetchingViewExample.gif)


## Requirements

## Installation

FetchingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FetchingView'
```

## Author

NeilsUltimateLab, neilsultimatelab@icloud.com

## License

FetchingView is available under the MIT license. See the LICENSE file for more info.
