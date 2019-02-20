//
//  MyaccountView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/10/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyaccountView: UIViewController{
    ///IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var IDlabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var NewEmailText: UITextField!
    @IBOutlet weak var NewPasswordText: UITextField!
    
    ///Property for keyboard
    private var observerTokens = Array<Any>()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recentAccount()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        hideKeyboard()
        
    }
    // MARK: Deinitialization
    deinit {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillHide,object:nil)
    }

    ///Mark: click screen to dismiss keyboard
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {}
    
    @objc func keyboardWillHide(notification: NSNotification) {}
    
    ///Alert create
    func displayMyAlertmessage(userMessage: String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true,completion:nil)
    }
    
    ///func to get recent Account from FireBase
    func recentAccount(){
        let user = Auth.auth().currentUser
        if let user = user{
            IDlabel.text = user.uid
            EmailLabel.text = user.email
            NameLabel.text = user.displayName
            imageView.image = UIImage(data: NSData(contentsOf: user.photoURL!)! as Data)
        }
    }
    
    ///IBAction for update email, update password and login out button
    @IBAction func UpdateEmail(_sender: Any){
        guard let NewEmail = NewEmailText.text else{
            displayMyAlertmessage(userMessage: "NewEmail must be required")
            return
        }
        
        let user = Auth.auth().currentUser
        
        if user?.email == NewEmail{
            displayMyAlertmessage(userMessage: "NewEmail should be different")
            return
        }
        
        user?.updateEmail(to: NewEmail){ error in
            if let error = error{
                self.displayMyAlertmessage(userMessage: error.localizedDescription)
            }
            else{
                self.displayMyAlertmessage(userMessage: "Email updated")
                self.EmailLabel.text = NewEmail
                self.NewEmailText.text = ""
            }
        }
        
    }
    
    @IBAction func UpdatePassword(_sender: Any){
        guard let NewPassword = NewPasswordText.text else{
            displayMyAlertmessage(userMessage: "New Password must be required")
            return
        }
        if NewPassword.count < 8{
            displayMyAlertmessage(userMessage: "Password must above 8 digits")
            return
        }
        let user = Auth.auth().currentUser
        user?.updatePassword(to: NewPassword){ error in
            if let error = error{
                self.displayMyAlertmessage(userMessage: error.localizedDescription)
            }else{
                self.displayMyAlertmessage(userMessage: "Password updated")
                self.NewPasswordText.text = ""
            }
        }
    }
    
    @IBAction func loginout(_sender : Any){
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
