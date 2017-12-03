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
    
    var onButtonTapAction: (()->Void)?
    
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
            //self.error = error
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
            if let retryButtonTitle = error.retryButtonTitles {
                prepareButtonStack(with: retryButtonTitle)
                parentStackView.addArrangedSubview(buttonStackView)
            }
            break
        case .fetchedData(_):
            self.listView.isHidden = false
            self.containerView.isHidden = true
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.addSubview(parentStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        parentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        parentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        return view
    }()
    
    var parentStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 22
        return stackView
    }()
    
    lazy var loadingStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.addArrangedSubview(self.indicatorView)
        stackView.addArrangedSubview(self.loadingLabel)
        return stackView
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.descriptionLabel)
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    
    var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Loading".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    
    var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.borderColor = button.tintColor.cgColor
        button.backgroundColor = button.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        return button
    }()
    
    func prepareViews() {
        self.parentView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 32).isActive = true
        containerView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0).isActive = true
    }
    
    private func prepareButtonStack(with buttons: [String]) {
        let buttons: [UIButton] = buttons.flatMap({ title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            return button
        })
        
        buttonStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        buttons.forEach{buttonStackView.addArrangedSubview($0)}
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        onButtonTapAction?()
    }
}
