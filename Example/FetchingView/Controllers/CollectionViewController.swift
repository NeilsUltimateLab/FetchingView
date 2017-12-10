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
        self.fetchingView.indicatorView.color = UIColor.white
        self.fetchingView.imageView.tintColor = UIColor.white
        self.fetchingView.titleLabel.textColor = .white
        self.fetchingView.descriptionLabel.textColor = .white
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.alwaysBounceVertical = true
    }
    
    fileprivate func setupDarkTheme() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.title = "JSONPlaceholder Users"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchingView()
        setupCollectionView()
        setupDarkTheme()
        
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
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.fetchResource()
    }
    
    @IBAction func errorActions(_ sender: UIBarButtonItem) {
        let sessionExpiredError = UIAlertAction(title: "Session Expired", style: .destructive) { (_) in
            self.fetchingState = .fetchedError(AppError.sessionExpired)
            //self.fetchingView.add([self.loginButton])
        }
        
        let notFoundError = UIAlertAction(title: "Not Found", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.notFound)
            //self.fetchingView.add([self.refreshButton])
        }
        
        let notReachableError = UIAlertAction(title: "Not reachable", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.notReachable)
            //self.fetchingView.add([self.settingsButton])
        }
        
        let requestTimedOutError = UIAlertAction(title: "Request Timed Out", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.requestTimedOut)
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(sessionExpiredError)
        alert.addAction(notFoundError)
        alert.addAction(notReachableError)
        alert.addAction(requestTimedOutError)
        self.present(alert, animated: true, completion: nil)
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
