//
//  ViewController.swift
//  FetchingView
//
//  Created by NeilsUltimateLab on 12/03/2017.
//  Copyright (c) 2017 NeilsUltimateLab. All rights reserved.
//

import UIKit
import FetchingView

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [Post] = []
    var fetchingView: FetchingView<[Post]>!
    
    var fetchingState: FetchingState<[Post]> = .fetching {
        didSet {
            self.fetchingView.fetchingState = self.fetchingState
            self.validate(fetchingState)
        }
    }
    
    fileprivate func validate(_ state: FetchingState<[Post]>) {
        switch state {
        case .fetchedData(let data):
            self.dataSource = data
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFetchingView()
        
        fetchResources()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupFetchingView() {
        self.fetchingView = FetchingView(listView: self.tableView, parentView: self.view)
        self.fetchingView.onButtonTapAction = { [weak self] in
            self?.fetchResources()
        }
    }
    
    func fetchResources() {
        self.fetchingState = .fetching
        
        Post.resource { (result) in
            if let error = result.error {
                self.fetchingState = .fetchedError(error)
            }
            if let value = result.value {
                self.fetchingState = .fetchedData(value)
            }
        }
    }
    
    
    @IBAction func refreshAction(_ sender: Any) {
        self.fetchResources()
    }

    @IBAction func errorActions(_ sender: Any) {
        let sessionExpiredError = UIAlertAction(title: "Session Expired", style: .destructive) { (_) in
            self.fetchingState = .fetchedError(AppError.sessionExpired)
        }
        
        let notFoundError = UIAlertAction(title: "Not Found", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.notFound)
        }
        
        let notReachableError = UIAlertAction(title: "Not reachable", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.notReachable)
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
    
    @IBAction func cancelAction(_ sender: Any) {
        self.fetchingState = .fetchedData([])
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
    
}

