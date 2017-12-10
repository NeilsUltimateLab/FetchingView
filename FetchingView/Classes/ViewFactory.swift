//
//  ViewFactory.swift
//  FetchingView
//
//  Created by Neil Jain on 10/12/17.
//

import UIKit

public class ViewFactory {
    public static func view(forBackgroundColor backgroundColor: UIColor = .white,
                            clipsToBounds: Bool = false) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.clipsToBounds = clipsToBounds
        return view
    }
    
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
    
    public static func imageView(image: UIImage? = nil, contentMode: UIViewContentMode = .center) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = contentMode
        return imageView
    }
    
    public static func activityIndicatorView(style: UIActivityIndicatorViewStyle = .gray,
                                             hidesWhenStopped: Bool = true,
                                             color: UIColor? = nil) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: style)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = hidesWhenStopped
        indicatorView.color = color
        return indicatorView
    }
    
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
    
    public static func segmentedControl(titles: String...) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        for (index, title) in titles.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }
    
}
