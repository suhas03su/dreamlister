//
//  AddDataViewController.swift
//  DreamLister
//
//  Created by Suhas on 12/08/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import UIKit
import Firebase

class AddDataViewController: UIViewController {

    
    @IBOutlet weak var imageViewButton: UIButton!
    @IBOutlet weak var dreamTitle: UITextField!
    @IBOutlet weak var dreamDescription: UITextField!
    @IBOutlet weak var dreamTarget: UITextField!
    @IBOutlet weak var dreamInformation: UITextField!
    var emailID = UserDefaults.standard.string(forKey: "emailID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let userUID = UserDefaults.standard.string(forKey: "userUID") {
            guard let newTitle = dreamTitle.text,
                let newDescription = dreamDescription.text,
                let newTarget = dreamTarget.text
            else { return }
            let information = self.dreamInformation.text ?? ""
            let db = Firestore.firestore()
            db.collection(userUID).document(newTitle).setData([
                "title": newTitle,
                "description": newDescription,
                "target": newTarget,
                "information": information
            ])
            UserDefaults.standard.set(false, forKey: "firebaseData")
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Success", message: "You are not logged in. Any doings without login will not work. Please close the app and login again!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func setupUI() {
        imageViewButton.layer.masksToBounds = false
        imageViewButton.layer.cornerRadius = imageViewButton.frame.height / 2
        imageViewButton.clipsToBounds = true
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
