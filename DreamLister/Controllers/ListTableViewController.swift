//
//  ListTableViewController.swift
//  DreamLister
//
//  Created by Suhas on 12/08/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ListTableViewController: UITableViewController {
    
    var dreamList: [NSDictionary] = []
    var indicator = UIActivityIndicatorView()
    var loadingView = UIView()
    var loadingLabel = UILabel()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .gray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonTapped))
        self.navigationItem.title = "Dream Lister"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.activityIndicator()
        indicator.startAnimating()
        if !UserDefaults.standard.bool(forKey: "firebaseData") {
            self.getData()
        } else {
            //Core Data
            let services  = Services()
            self.dreamList = services.getDataFromCoreData()
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.loadingLabel.text = ""
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dreamList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dreams")
        cell.textLabel?.text = self.dreamList[indexPath.row]["title"] as? String
        return cell
    }
    
    
    private func getData() {
        if let userUID = UserDefaults.standard.string(forKey: "userUID") {
            let db = Firestore.firestore()
            db.collection(userUID).getDocuments{ (queryResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if queryResult!.count > 0 {
                        UserDefaults.standard.set(true, forKey: "firebaseData")
                        self.dreamList = []
                        for document in queryResult!.documents {
                            self.dreamList.append(document.data() as? NSDictionary ?? [:])
                        }
                        let services = Services()
                        services.addDataToCoreData(documents: self.dreamList)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        self.loadingLabel.text = ""
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Success", message: "You are not logged in. Any doings without login will not work. Please close the app and login again!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func addButtonTapped(sender: UIBarButtonItem) {
        let addDataViewController = AddDataViewController()
        self.navigationController?.pushViewController(addDataViewController, animated: true)
    }
    
    @objc func signOutButtonTapped(sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userUID")
            UserDefaults.standard.removeObject(forKey: "emailID")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "firebaseData")
            let services = Services()
            services.deleteDataFromCoreData()
            DreamLister.userUID = ""
            
            let alert = UIAlertController(title: "Success", message: "You have been logged out successfully. Any doings without login will not work. Please close the app and login again!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } catch {
            print("Something went wrong")
        }
    }
    
    func activityIndicator() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        indicator.style = .gray
        indicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // Adds text and spinner to the view
        loadingView.addSubview(indicator)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
    }
    
}

//    self.navigationItem.rightBarButtonItem = self.editButtonItem (When this is used the below can be used)
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        if editing {
//            print("Edit button clicked")
//        }
//    }
