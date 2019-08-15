//
//  SignUpViewController.swift
//  DreamLister
//
//  Created by Suhas on 12/08/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailid: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpUser(_ sender: Any) {
        guard let email = emailid.text, let passwordText = password.text else { return }
        Auth.auth().createUser(withEmail: email, password: passwordText) { (user, error) in
            if error != nil {
                self.showAlertMessage(title: "Error", message: error!.localizedDescription, isSuccessful: false)
            } else {
                    self.showAlertMessage(title: "Success", message: "Your account has been created Successfully!. User UID : \(Auth.auth().currentUser!.uid)", isSuccessful: true)
                UserDefaults.standard.set(email, forKey: "emailID")
                UserDefaults.standard.set(passwordText, forKey: "password")
                DreamLister.userUID = Auth.auth().currentUser!.uid
                UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "userUID")
                }
            }
        }
    

    @IBAction func backToLoginScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlertMessage(title: String, message: String, isSuccessful: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            if isSuccessful {
                let listTableViewController = ListTableViewController()
                let navigationController = UINavigationController(rootViewController: listTableViewController)
                self.present(navigationController, animated:true, completion: nil)
            } else {
                
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}
