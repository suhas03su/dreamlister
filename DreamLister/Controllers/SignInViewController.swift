//
//  ViewController.swift
//  DreamLister
//
//  Created by Suhas on 11/08/19.
//  Copyright © 2019 Suhas. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var emailid: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkIfLoggedIn()
    }
    
    
    private func checkIfLoggedIn() {
        let UUID = UserDefaults.standard.string(forKey: "userUID") ?? ""
        if UUID != "" {
            DispatchQueue.main.async {
                let email = UserDefaults.standard.string(forKey: "emailID")
                let passwordText = UserDefaults.standard.string(forKey: "password")
                Auth.auth().signIn(withEmail: email!, password: passwordText!) { (result, error) in
                    if error != nil {
                        self.showAlertMessage(title: "Error", message: error!.localizedDescription)
                    } else {
                        self.removeDataFromUserDefaults()
                        UserDefaults.standard.set(email, forKey: "emailID")
                        UserDefaults.standard.set(passwordText, forKey: "password")
                        DreamLister.userUID = Auth.auth().currentUser!.uid
                        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "userUID")
                        let listTableViewController = ListTableViewController()
                        let navigationController = UINavigationController(rootViewController: listTableViewController)
                        self.present(navigationController, animated:true, completion: nil)
                    }
                }
            }
        }
    }

    @IBAction func signUp(_ sender: Any) {
        let signUpController = SignUpViewController()
        self.present(signUpController, animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailid.text, let passwordText = password.text else { return }
        Auth.auth().signIn(withEmail: email, password: passwordText) { (result, error) in
            if error != nil {
                self.showAlertMessage(title: "Error", message: error!.localizedDescription)
            } else {
                UserDefaults.standard.set(email, forKey: "emailID")
                UserDefaults.standard.set(passwordText, forKey: "password")
                DreamLister.userUID = Auth.auth().currentUser!.uid
                UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "userUID")
                let listTableViewController = ListTableViewController()
                let navigationController = UINavigationController(rootViewController: listTableViewController)
                self.present(navigationController, animated:true, completion: nil)
            }
        }
    }
    
    private func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func removeDataFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "emailID")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
}

