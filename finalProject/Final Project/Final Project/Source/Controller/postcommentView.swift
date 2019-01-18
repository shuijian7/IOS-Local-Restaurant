//
//  postcommentView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/8/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class postcommentView : UIViewController, UITextViewDelegate{
    
    ///Mark:IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    ///Mark: Properties for coreData, textdefault, row and posts Array
    var result_restaurant : Restaurant!
    var textdefault : String = ""
    var row : Int?
    var posts = [Post]()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        ///Create Done button above the keyboard to dismiss the keyBoard
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        toolbar.items = [space, doneButton]
        
        textView.inputAccessoryView = toolbar
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        
    }
    
    ///Mark: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if textdefault != ""{
            navigationItem.title = "Edit"
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(Editbutton(_sender:)))
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-save-as-25")
        }
        else {
            navigationItem.title = "Write"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButton))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePostbutton(_sender:)))
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-forward-arrow-25")
        }
        textView.text = textdefault
    }
    
    ///IBAction Post cancel and Edit Button
    @IBAction func handlePostbutton(_sender:Any){
        
        guard let userProfile = UserService.currentUserProfile else{return}
        if textView.text == "" {
            let myAlert = UIAlertController(title: "Alert", message: "Empty is not required", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.present(myAlert, animated:true,completion:nil)
            return
        }
        let postRef = Database.database().reference().child("post").childByAutoId()
        
        let postObject = [
            "author":[
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString],
            "text": textView.text,
            "timestamp": [".sv":"timestamp"],
            "restaurant": result_restaurant.name ?? 0
            ] as [String : Any]
        
        postRef.setValue(postObject,withCompletionBlock: { error, ref in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                print("Error")
            }
        })
    }
    
    ///IBAction Cancel button
    @IBAction func handleCancelButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {super.dismiss(animated: flag, completion: completion)})
    }
    
    ///IBAction Savebutton
    @IBAction func Editbutton(_sender:Any) {
        if textView.text == ""{
            let myAlert = UIAlertController(title: "Alert", message: "Empty is not required", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.present(myAlert, animated:true,completion:nil)
            return
        }
        guard let userProfile = UserService.currentUserProfile else{return}
        
        let postRef = Database.database().reference().child("post").child(posts[row!].id)
        let postObject = [
            "author":[
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString],
            "text": textView.text,
            "timestamp": [".sv":"timestamp"],
            "restaurant": result_restaurant.name ?? 0
            ] as [String : Any]

        postRef.setValue(postObject,withCompletionBlock: { error, ref in
            if let error = error{
                print("Error",error.localizedDescription)
            }
        })
        
    }
}
