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
    
    var dataSource: [String] = []
    var fetchingView: FetchingView<[String]>!
    
    var fetchingState: FetchingState<[String]> = .fetching {
        didSet {
            self.fetchingView.fetchingState = self.fetchingState
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.fetchingState = .fetchedData([""])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")!
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
}

