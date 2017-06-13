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
import FirebaseStorage
import FirebaseDatabase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .twitter
        tf.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
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
        button.isEnabled = false
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let original = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(original.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        // Override button styles in order to accomplish design requirements
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTextInputChanged() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
                          usernameTextField.text?.count ?? 0 > 1 &&
                          passwordTextField.text?.count ?? 0 > 6
        
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(r: 17, g: 154, b: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(r: 149, g: 204, b: 244)
            signUpButton.isEnabled = false
        }
    }
    
    @objc func registerUser() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            user, error in
            
            if let error = error {
                self.simpleAlert(
                    title: "Error at registering",
                    message: "We couldn't register you in the system. Sorry. Err: \(error.localizedDescription)"
                )
                return
            }
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
            let filename = NSUUID().uuidString
            
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil) {
                metadata, err in
                
                if let err = err {
                    print ("Failed to upload image", err)
                    return
                }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                print("Successfully uploaded image", profileImageUrl)
                
                guard let uid = user?.uid else { return }
                
                let usernameValues = [
                    "username": username,
                    "profileImageUrl": profileImageUrl
                ]
                let values = [uid: usernameValues]
                Database.database().reference().child("users").updateChildValues(values) {
                    err, ref in
                    
                    if let err = err {
                        self.simpleAlert(title: "Error at registering", message: "We couldn't register you.")
                        print("Error at registering:", err)
                        return
                    }
                    
                    self.simpleAlert(
                        title: "Success!",
                        message: "Successfully created user \(uid)",
                        buttonTitle: "Woot!"
                    )
                }
            }
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














