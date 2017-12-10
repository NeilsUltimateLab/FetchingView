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
    
    public var fetchingState: FetchingState<A> = .fetching {
        didSet {
            validate(state: fetchingState)
        }
    }
    
    public init(listView: UIView, parentView: UIView) {
        self.listView = listView
        self.parentView = parentView
        
        prepareViews()
    }
    
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
    
    lazy var containerView: UIView = {
        let view = ViewFactory.view(forBackgroundColor: .clear, clipsToBounds: true)
        view.addSubview(parentStackView)
        parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        parentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        parentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        return view
    }()
    
    var parentStackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .fill,
                                              distribution: .fill,
                                              spacing: 22)
        return stackView
    }()
    
    lazy var loadingStackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 16)
        stackView.addArrangedSubview(self.indicatorView)
        stackView.addArrangedSubview(self.loadingLabel)
        return stackView
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 4)
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.descriptionLabel)
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 4)
        return stackView
    }()
    
    
    public var indicatorView: UIActivityIndicatorView = {
        let view = ViewFactory.activityIndicatorView(style: .gray,
                                                     hidesWhenStopped: true)
        return view
    }()
    
    public var loadingLabel: UILabel = {
        let label = ViewFactory.label(title: "Loading".uppercased(),
                                      textAlignment: .center,
                                      textColor: .gray,
                                      numberOfLines: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    public var titleLabel: UILabel = {
        let label = ViewFactory.label(title: "",
                                      textAlignment: .center,
                                      textColor: .gray,
                                      numberOfLines: 0,
                                      lineBreakMode: .byWordWrapping)
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.medium)
        return label
    }()
    
    public var descriptionLabel: UILabel = {
        let label = ViewFactory.label(title: "",
                                      textAlignment: .center,
                                      textColor: .gray,
                                      numberOfLines: 0,
                                      lineBreakMode: .byWordWrapping)
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    public var imageView: UIImageView = {
        let imageView = ViewFactory.imageView(image: nil,
                                              contentMode: .scaleAspectFit)
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    
    func prepareViews() {
        self.parentView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 32).isActive = true
        containerView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0).isActive = true
    }
    
    public func add(_ buttons: [UIButton]) {
        buttonStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for button in buttons {
            buttonStackView.addArrangedSubview(button)
        }
        buttonStackView.removeFromSuperview()
        parentStackView.addArrangedSubview(buttonStackView)
    }
    
}
