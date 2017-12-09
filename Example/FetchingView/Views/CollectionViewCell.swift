//
//  CollectionViewCell.swift
//  FetchingView_Example
//
//  Created by Neil Jain on 09/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let idContainerView = idLabel.superview {
            idContainerView.layer.cornerRadius = idContainerView.frame.height/2
        }
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.backgroundColor = .white
    }
    
    func configure(with user: User) {
        self.idLabel.text = "\(user.id ?? 0)"
        self.nameLabel.text = user.name
    }
    
}
