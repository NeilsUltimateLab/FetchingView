//
//  AppHUD.swift
//  FetchingView
//
//  Created by Neil Jain on 10/12/17.
//

import UIKit

public class AppHUD {
    
    public init() {}
    
    public enum `Type` {
        case definite(String?, String?)
        case indefinite
        case message(String?, String?, TimeInterval)
    }
    
    var isAlreayRenderedOnWindow: Bool = false
    
    var backgroundView: UIView = {
        return ViewFactory.view(forBackgroundColor: UIColor.black.withAlphaComponent(0.3), clipsToBounds: true)
    }()
    
    var containerView: UIView = {
        let view = ViewFactory.view(forBackgroundColor: .clear, clipsToBounds: true)
        view.layer.cornerRadius = 9.0
        view.layer.masksToBounds = true
        return view
    }()
    
    var visualEffectView: UIVisualEffectView = {
        return ViewFactory.visualEffectView(blurEffectStyle: .extraLight)
    }()
    
    public var activityIndicator: UIActivityIndicatorView = {
        return ViewFactory.activityIndicatorView(style: .whiteLarge,
                                                 hidesWhenStopped: true,
                                                 color: UIColor.gray)
    }()
    
    public var titleLabel: UILabel = {
        let label = ViewFactory.label(title: "",
                                 textAlignment: .center,
                                 numberOfLines: 1,
                                 lineBreakMode: .byTruncatingTail)
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        return label
    }()
    
    public var messageLabel: UILabel = {
        let label = ViewFactory.label(title: "",
                                      textAlignment: .center,
                                      numberOfLines: 0,
                                      lineBreakMode: .byWordWrapping)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    public var progressView: UIProgressView = {
        return ViewFactory.progressView()
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = ViewFactory.stackView(forAxis: .vertical,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: 5.0)
        return stackView
    }()
    
    private func constrainAllEdges(of childView: UIView,
                                   to parentView: UIView,
                                   top: CGFloat = 0,
                                   left: CGFloat = 0,
                                   right: CGFloat = 0,
                                   bottom: CGFloat = 0) {
        parentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: left),
            childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: top),
            childView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -right),
            childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -bottom)
            ])
    }
    
    private func constrainCenter(of childView: UIView, to parentView: UIView) {
        parentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            childView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
            ])
    }
    
    private func setupHUD(for type: Type) {
        guard let window = UIApplication.shared.keyWindow else { return }
        constrainAllEdges(of: backgroundView, to: window)
        backgroundView.alpha = 0
        
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView = view
        
        
        constrainAllEdges(of: visualEffectView, to: containerView)
        constrainCenter(of: containerView, to: window)
        self.containerView.layer.cornerRadius = 9.0
        self.containerView.clipsToBounds = true
        
        
        let heightAnchorConstraint = containerView.heightAnchor.constraint(equalToConstant: 100)
        let widthAnchorConstraint = containerView.widthAnchor.constraint(equalToConstant: 100)
        let leftAnchorConstraint = containerView.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 50)
        
        switch type {
        case .indefinite:
            widthAnchorConstraint.isActive = true
            heightAnchorConstraint.isActive = true
            self.setIndifiniteHUDMode()
            
        case let .definite(title, message):
            widthAnchorConstraint.isActive = false
            leftAnchorConstraint.isActive = true
            self.setDefiniteHUDMode(title: title, message: message)
            
        case .message(let title, let message, let delay):
            heightAnchorConstraint.isActive = false
            widthAnchorConstraint.isActive = false
            leftAnchorConstraint.isActive = true
            self.setMessageHUDMode(title: title, message: message, delay: delay)
        }
        
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        containerView.alpha = 0
        
        window.endEditing(true)
    }
    
    private func setIndifiniteHUDMode() {
        self.activityIndicator.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        self.messageLabel.removeFromSuperview()
        self.progressView.removeFromSuperview()
        
        constrainCenter(of: activityIndicator, to: containerView)
        activityIndicator.startAnimating()
    }
    
    private func setDefiniteHUDMode(title: String? = nil, message: String? = nil) {
        self.activityIndicator.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        self.messageLabel.removeFromSuperview()
        self.progressView.removeFromSuperview()
        self.progressView.setProgress(0, animated: false)
        
        constrainAllEdges(of: stackView, to: containerView, top: 8, left: 16, right: 16, bottom: 16)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(progressView)
        titleLabel.text = title
        messageLabel.text = message
    }
    
    private func setMessageHUDMode(title: String?, message: String?, delay: TimeInterval) {
        self.activityIndicator.removeFromSuperview()
        self.progressView.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        
        constrainAllEdges(of: stackView, to: containerView, top: 16, left: 16, right: 16, bottom: 16)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
        titleLabel.text = title
        messageLabel.text = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.hideHUD()
        }
    }
    
    private func animateHUD() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.backgroundView.alpha = 1
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }, completion: {(success)in
            if success {
                self.isAlreayRenderedOnWindow = true
            }
        })
    }
    
    public func hideHUD(completion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
        }) { (succeed) in
            if succeed {
                self.backgroundView.removeFromSuperview()
                self.containerView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
                self.progressView.removeFromSuperview()
                self.titleLabel.removeFromSuperview()
                self.messageLabel.removeFromSuperview()
                self.isAlreayRenderedOnWindow = false
                completion?()
            }
        }
    }
    
    public func updateProgress(percetage: Float, shouldHideAfterCompletion: Bool, completion: (()->Void)? = nil) {
        self.progressView.setProgress(percetage, animated: true)
        if shouldHideAfterCompletion {
            if percetage >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                    self?.hideHUD(completion: completion)
                })
            }
        }else {
            completion?()
        }
    }
    
    public func showHUD() {
        guard !isAlreayRenderedOnWindow else { return }
        self.setupHUD(for: .indefinite)
        self.animateHUD()
    }
    
    public func showHud(title: String?, message: String?, delay: TimeInterval) {
        guard !isAlreayRenderedOnWindow else { return }
        self.setupHUD(for: .message(title, message, delay))
        self.animateHUD()
    }
    
    public func showDefiniteHUD(title: String?, message: String?) {
        guard !isAlreayRenderedOnWindow else { return }
        self.setupHUD(for: .definite(title, message))
        self.animateHUD()
    }
    
}
