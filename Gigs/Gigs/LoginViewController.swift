//
//  LoginViewController.swift
//  Gigs
//
//  Created by Stephanie Bowles on 5/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    var gigController: GigController!
    var loginType = LoginType.signUp
    
    @IBOutlet weak var signSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func signingTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loginType = .signUp
            self.signButton.setTitle("Sign up", for: .normal )
        } else {
            self.loginType = .signIn
            self.signButton.setTitle("Sign in", for: .normal)
        }
    }
    

    @IBAction func signButtonTapped(_ sender: UIButton) {
        guard let gigController = self.gigController else {return}
        if let username = self.usernameField.text,
            !username.isEmpty,
            let password = self.passwordField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
               gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occured during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.signSegmentedControl.selectedSegmentIndex = 1
                                self.signButton.setTitle("Sign in", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.logIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error ocurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    // MARK: - Navigation



}
