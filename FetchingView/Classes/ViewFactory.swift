//
//  ViewFactory.swift
//  FetchingView
//
//  Created by Neil Jain on 10/12/17.
//

import UIKit

public class ViewFactory {
    
    /// A simple autolayout ready UIView with some default properties.
    ///
    /// - Parameters:
    ///   - backgroundColor: *default* is `.white`
    ///   - clipsToBounds: *default* is `false`
    /// - Returns: returns UIView with above properties.
    public static func view(forBackgroundColor backgroundColor: UIColor = .white,
                            clipsToBounds: Bool = false) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.clipsToBounds = clipsToBounds
        return view
    }
    
    
    /// A simple autolayout ready `UIStackView` with some default properties.
    ///
    /// - Parameters:
    ///   - axis: *default* is `.vertical`
    ///   - alignment: *default* is `.fill`
    ///   - distribution: *default* is `.fill`
    ///   - spacing: *default* is `0`
    /// - Returns: returns `UIStackView` with above properties.
    public static func stackView(forAxis axis: UILayoutConstraintAxis = .vertical,
                                 alignment: UIStackViewAlignment = .fill,
                                 distribution: UIStackViewDistribution = .fill,
                                 spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
    
    
    /// A simple autolayout ready `UILabel` with some default properties.
    ///
    /// - Parameters:
    ///   - textAlignment: *default* is `.center`
    ///   - textColor: *default* is `.black`
    ///   - numberOfLines: *default* is `0`
    ///   - lineBreakMode: *default* is `.byTruncatingTail`
    /// - Returns: returns `UILabel` with above properties.
    public static func label(title: String,
                             textAlignment: NSTextAlignment = .center,
                             textColor: UIColor = .black,
                             numberOfLines: Int = 0,
                             lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        return label
    }
    
    /// A simple autolayout ready `UIImageView` with some default properties.
    ///
    /// - Parameters:
    ///   - image: *default* is `nil`
    ///   - contentMode: *default* is `.center`
    /// - Returns: returns `UILabel` with above properties.
    public static func imageView(image: UIImage? = nil,
                                 contentMode: UIViewContentMode = .center) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = contentMode
        return imageView
    }
    
    /// A simple autolayout ready `UIActivityIndicatorView` with some default properties.
    ///
    /// - Parameters:
    ///   - style: *default* is `.gray`
    ///   - hidesWhenStopped: *default* is `true`
    ///   - color: *default* is `nil`
    /// - Returns: returns `UIActivityIndicatorView` with above properties.
    public static func activityIndicatorView(style: UIActivityIndicatorViewStyle = .gray,
                                             hidesWhenStopped: Bool = true,
                                             color: UIColor? = nil) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: style)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = hidesWhenStopped
        indicatorView.color = color
        return indicatorView
    }
    
    
    /// A simple autolayout ready `UIButton` with some default properties.
    ///
    /// - Parameters:
    ///   - type: *default* is `.system`
    ///   - title: *default* is `"Button"`
    ///   - image: *default* is `nil`
    ///   - tintColor: *default* is `.white`
    /// - Returns: returns `UIButton` with above properties.
    public static func button(type: UIButtonType = .system,
                              title: String? = "Button",
                              image: UIImage? = nil,
                              tintColor: UIColor = .white) -> UIButton {
        let button = UIButton(type: type)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        return button
    }
    
    /// A simple autolayout ready `UISegmentedControl` with some default properties.
    ///
    /// - Parameter titles: is a `variadic` parameter.
    /// - Returns: returns `UISegmentedControl` with above properties.
    public static func segmentedControl(titles: String...) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        for (index, title) in titles.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }
    
    public static func visualEffectView(blurEffectStyle style: UIBlurEffectStyle) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }
    
    public static func progressView(progressViewStyle style: UIProgressViewStyle = .default,
                                    isUserInterationEnabled interactionEnabled: Bool = false,
                                    trackImage: UIImage = UIImage(),
                                    trackTintColor: UIColor = .lightGray,
                                    progressTintColor: UIColor = UIColor.blue) -> UIProgressView {
        let pv = UIProgressView(progressViewStyle: style)
        pv.isUserInteractionEnabled = interactionEnabled
        pv.trackImage = trackImage
        pv.trackTintColor = trackTintColor
        pv.progressTintColor = progressTintColor
        return pv
    }
    
}
