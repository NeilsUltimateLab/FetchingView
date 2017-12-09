//
//  CollectionViewController.swift
//  FetchingView_Example
//
//  Created by Neil Jain on 09/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FetchingView

class CollectionViewController: UIViewController {

    var dataSource: [User] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchingView: FetchingView<[User]>!
    
    var fetchingState: FetchingState<[User]> = .fetching {
        didSet {
            self.fetchingView.fetchingState = fetchingState
            self.validate(fetchingState)
        }
    }
    
    fileprivate func validate(_ state: FetchingState<[User]>) {
        switch state {
        case .fetchedData(let data):
            self.dataSource = data
            self.collectionView.reloadData()
        default:
            break
        }
    }
    
    fileprivate func setupFetchingView() {
        self.fetchingView = FetchingView(listView: self.collectionView, parentView: self.view)
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.backgroundColor = UIColor.groupTableViewBackground
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchingView()
        setupCollectionView()
        
        fetchResource()
    }
    
    fileprivate func fetchResource() {
        self.fetchingState = .fetching
        User.resource { (result) in
            if let error = result.error {
                self.fetchingState = .fetchedError(error)
            }
            if let value = result.value {
                self.fetchingState = .fetchedData(value)
            }
        }
    }

}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellId", for: indexPath) as! CollectionViewCell
        cell.configure(with: self.dataSource[indexPath.item])
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = (collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right) / 3
        return CGSize(width: availableWidth - 12, height: availableWidth + 21)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
