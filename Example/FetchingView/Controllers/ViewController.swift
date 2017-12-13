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
        setupTitle()
        
        fetchResources()
    }
    
    func setupTitle() {
        self.title = "JSONPlaceholder Post"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(fetchResources), for: .touchUpInside)
        button.setTitle("Reload", for: .normal)
        return button
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.setTitle("Open settings", for: .normal)
        button.addTarget(self, action: #selector(openSettings(_:)), for: .touchUpInside)
        return button
    }()
    
    var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        button.backgroundColor = button.tintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    @objc func loginAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Login", message: "Please login!", preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login", style: .cancel, handler: {_ in
            self.fetchResources()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openSettings(_ sender: UIButton) {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func setupFetchingView() {
        self.fetchingView = FetchingView(listView: self.tableView, parentView: self.view)
    }
    
    @objc func fetchResources() {
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
            self.fetchingView.add([self.loginButton])
        }
        
        let notFoundError = UIAlertAction(title: "Not Found", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.notFound)
            self.fetchingView.add([self.refreshButton])
        }
        
        let notReachableError = UIAlertAction(title: "Not reachable", style: .default) { (_) in
            self.fetchingState = .fetchedError(AppError.notReachable)
            self.fetchingView.add([self.settingsButton])
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
    
    @IBAction func hudActions(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let showHUDAction = UIAlertAction(title: "Indefinite HUD", style: .default) { (_) in
            self.showHUD()
        }
        
        let messageHUDAction = UIAlertAction(title: "Message HUD", style: .default) { (_) in
            self.showMessageHUD()
        }
        
        alert.addAction(showHUDAction)
        alert.addAction(messageHUDAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showHUD() {
        self.fetchingView.showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.fetchingView.hideHUD()
        }
    }
    
    func showMessageHUD() {
        self.fetchingView.showHUD(title: "Awesome!", message: "Your request is submitted successfully.", delay: 2.0)
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

