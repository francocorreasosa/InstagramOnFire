//
//  ViewController.swift
//  Instagram
//
//  Created by Franco Correa on 6/11/17.
//  Copyright © 2017 Franco Correa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return button
    }()
    
    @objc func registerUser() {
        let email = "franco@francocorrea.com.uy"
        let password = "lolxd21"
        
        Auth.auth().createUser(withEmail: email, password: password) {
            user, error in
            
            if let error = error {
                self.simpleAlert(
                    title: "Error at registering",
                    message: "We couldn't register you in the system. Sorry. Err: \(error.localizedDescription)"
                )
                return
            }
            
            let uid = String(describing: user?.uid)
            self.simpleAlert(
                title: "Success!",
                message: "Successfully created user \(uid)",
                buttonTitle: "Woot!"
            )
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        plusPhotoButton.anchor(top: view.topAnchor,
                               bottom: nil,
                               left: nil,
                               right: nil,
                               paddingTop: 40,
                               paddingBottom: 0,
                               paddingLeft: 0,
                               paddingRight: 0,
                               width: 140,
                               height: 140)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         bottom: nil,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingBottom: 0,
                         paddingLeft: 40,
                         paddingRight: -40,
                         width: 0,
                         height: 200)
    }
    
}














