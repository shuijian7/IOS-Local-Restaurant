//
//  loginpageView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/5/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit
import Firebase

class loginpageView : UIViewController{
    
    ///Mark: IBOutlet
    @IBOutlet weak var userEmailtext: UITextField!
    @IBOutlet weak var userPasswordtext: UITextField!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        hideKeyboard()
    }
    // MARK: Deinitialization
    deinit {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillHide,object:nil)
    }

    ///Mark: Way to avoiding the warning TabBarController is not on Window by override preparing to specific viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurant"{
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![0] as! UINavigationController
            let viewController = nav.topViewController as! RestaurantView
            viewController.isSearching = false
        }
    }
    
    ///IBAction for login button and Alert func
    @IBAction func loginButton(_sender:Any){
        let userEmail = userEmailtext.text
        let userPassword = userPasswordtext.text
        Auth.auth().signIn(withEmail: userEmail!, password: userPassword!){user, error in
            if error == nil && user != nil{
                self.self.userEmailtext.text = ""
                self.userPasswordtext.text = ""
                self.performSegue(withIdentifier: "toRestaurant", sender: self)
                
            }
            else{
                print("Error log in")
                self.resetForm()
            }
            
        }
    }
    func resetForm(){
        let myAlert = UIAlertController(title: "Error log in", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true,completion:nil)
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
    
    private var observerTokens = Array<Any>()
    
    
}



