//
//  FetchingView.swift
//  FetchingView
//
//  Created by Neil Jain on 03/12/17.
//

import Foundation

public class FetchingView<A> {
    
    var listView: UIView
    var parentView: UIView
    
    let appHUD: AppHUD = AppHUD()
    
    // MARK: - Initialiser -
    
    /// FetchingView Mechanism
    ///
    /// - Parameters:
    ///   - listView: This view could be your `tableView`, `collectionView`, `scrollView` or some other `UIView`. `listView` will hide when fetching state views were rendered.
    ///   - parentView: ParentView may be the `superview` of `listView`. ParentView will be the `containerView` for the fetching state views.
    public init(listView: UIView, parentView: UIView) {
        self.listView = listView
        self.parentView = parentView
        
        prepareViews()
    }
    
    // MARK: - State Machine -
    /// Tracking states of web-request
    public var fetchingState: FetchingState<A> = .fetching {
        didSet {
            validate(state: fetchingState)
        }
    }
    
    /// When `fetchingState` changes this method will be called.
    ///
    /// - Parameter state: `fetchingState`
    private func validate(state: FetchingState<A>) {
        self.listView.isHidden = true
        self.containerView.isHidden = false

        switch state {
        case .fetching:
            self.imageView.removeFromSuperview()
            self.buttonStackView.removeFromSuperview()
            self.labelStackView.removeFromSuperview()
            parentStackView.addArrangedSubview(loadingStackView)
            indicatorView.startAnimating()
            
        case .fetchedError(let error):
            loadingStackView.removeFromSuperview()
            buttonStackView.removeFromSuperview()
            imageView.removeFromSuperview()
            if let image = error.image {
                imageView.image = image
                parentStackView.addArrangedSubview(imageView)
            }
            parentStackView.addArrangedSubview(labelStackView)
            titleLabel.text = error.title
            descriptionLabel.text = error.subtitle
            
        case .fetchedData(_):
            self.listView.isHidden = false
            self.containerView.isHidden = true
        }
    }
    
    // MARK: - UIElements -
    /// Parent `containerView` for the all stackViews.
    lazy var containerView: UIView = {
        let view = ViewFactory.view(forBackgroundColor: .clear, clipsToBounds: true)
        view.addSubview(parentStackView)
        parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        parentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        parentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        return view
    }()
    
    
    // MARK: UIStackViews
    /// Parent StackView that contains `imageStackView` ,`titleStackView`, `textStackView`, `buttonStackView`.
    var parentStackView: UIStackView = {
        return ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .fill,
                                              distribution: .fill,
                                              spacing: 22)
    }()
    
    
    /// Loading StackView contains `UIActivityIndicatorView`, `UILabel`.
    lazy var loadingStackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 16)
        stackView.addArrangedSubview(self.indicatorView)
        stackView.addArrangedSubview(self.loadingLabel)
        return stackView
    }()
    
    
    /// Label StackView contains `UILabel`s for `title` and `description`
    lazy var labelStackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 4)
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.descriptionLabel)
        return stackView
    }()
    
    /// Button StackView *will contain the response buttons provided by the* **API client** .
    lazy var buttonStackView: UIStackView = {
        return ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 4)
    }()
    
    
    /// UIActivityIndicatorView will be rendered when `fetchingState` is `.fetching`
    public var indicatorView: UIActivityIndicatorView = {
        return ViewFactory.activityIndicatorView(style: .gray,
                                                     hidesWhenStopped: true)
    }()
    
    // MARK: UILabels
    
    /// `loadingLabel` will be rendered below `indicatorView` when `fetchingState` is      `fetching`.
    ///
    /// The default text is "`LOADING`".
    ///
    /// `loadingLabel`'s text can be changed by API User.
    public var loadingLabel: UILabel = {
        let label = ViewFactory.label(title: "Loading".uppercased(),
                                      textAlignment: .center,
                                      textColor: .gray,
                                      numberOfLines: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    /// `titleLabel` will be rendered when `fetchingState` is `fetchedError(AppErrorProvider)`.
    ///
    /// The default text is empty text.
    ///
    /// `titleLabel`'s text will be changed `AppErrorProvider`'s `title` property.
    public var titleLabel: UILabel = {
        let label = ViewFactory.label(title: "",
                                      textAlignment: .center,
                                      textColor: .gray,
                                      numberOfLines: 0,
                                      lineBreakMode: .byWordWrapping)
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.medium)
        return label
    }()
    
    /// `descriptionLabel` will be rendered when `fetchingState` is `fetchedError(AppErrorProvider)`.
    ///
    /// The default text is empty text.
    ///
    /// `descriptionLabel`'s text will be changed `AppErrorProvider`'s `subtitle` property.
    public var descriptionLabel: UILabel = {
        let label = ViewFactory.label(title: "",
                                      textAlignment: .center,
                                      textColor: .gray,
                                      numberOfLines: 0,
                                      lineBreakMode: .byWordWrapping)
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    // MARK: UIImageView
    
    /// `imageView` will be rendered when `fetchingState` is `fetchedError(AppErrorProvider)`.
    ///
    /// The default image is `nil`.
    ///
    /// `imageView`'s image will be changed `AppErrorProvider`'s `image` property.
    public var imageView: UIImageView = {
        let imageView = ViewFactory.imageView(image: nil,
                                              contentMode: .scaleAspectFit)
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    
    // MARK: - Utilities
    
    func prepareViews() {
        self.parentView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 32).isActive = true
        containerView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0).isActive = true
    }
    
    
    /// To add `UIButton`s to `buttonStackView`. `FetchingView` will not handle any `UIButton` touch `events`
    ///
    /// - Parameter buttons: `UIButton`'s `targetAction` must be set by API User.
    public func add(_ buttons: [UIButton]) {
        buttonStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for button in buttons {
            buttonStackView.addArrangedSubview(button)
        }
        buttonStackView.removeFromSuperview()
        parentStackView.addArrangedSubview(buttonStackView)
    }
    
    public func showHUD() {
        appHUD.showHUD()
    }
    
    public func showHUD(title: String?, message: String?, delay: TimeInterval) {
        appHUD.showHud(title: title, message: message!, delay: delay)
    }
    
    public func showProgressHUD(title: String?, message: String?) {
        appHUD.showDefiniteHUD(title: title, message: message)
    }
    
    public func updateProgressHUD(percentage: Float,
                           shouldHideAfterCompletion autoHide: Bool = true,
                           completion: (()->Void)? = nil) {
        appHUD.updateProgress(percetage: percentage,
                              shouldHideAfterCompletion: autoHide,
                              completion: completion)
    }
    
    public func hideHUD() {
        appHUD.hideHUD(completion: nil)
    }
}
