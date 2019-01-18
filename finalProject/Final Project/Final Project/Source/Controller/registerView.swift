//
//  registerView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/5/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit
import Firebase

class registerView : UIViewController{
    
    ///Mark: IBOutlet
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userEmailtext: UITextField!
    @IBOutlet weak var userPasswordtext: UITextField!
    @IBOutlet weak var repeatPasswordtext: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var taptochange: UIButton!
    
    ///Mark: Properties for coredata,keyboard and insert image
    var imagePicker : UIImagePickerController!
    private var observerTokens = Array<Any>()
    private var userService: TestService?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Mark: gesture the image can be tapped to changed selfie in Gallery or using camera
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        ///Mark: Tap to change has same work to image
        taptochange.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)

        let willShowObserverToken = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] in
            self.adjustSafeArea(forWillShowKeyboardNotification: $0)
        }
        let willHideObserverToken = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] in
            self.adjustSafeArea(forWillHideKeyboardNotification: $0)
        }
        observerTokens += [willShowObserverToken, willHideObserverToken]
         hideKeyboard()
    }
    // MARK: Deinitialization
    deinit {
        for observerToken in observerTokens {
            NotificationCenter.default.removeObserver(observerToken)
        }
    }
    
    ///Mark: function to pick the image either from the Camera or the Gallery
    @objc func openImagePicker(_sender : Any){
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.camera()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.photoLibrary()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //actionSheet.popoverPresentationController?, Alertsheet will appear at the middle of View
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera()
    {
        ///Mark: Check whether using simulator or not
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
           self.displayMyAlertmessage(userMessage: "Divice has no camera")
            
        }
        else{
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker,animated: true,completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    
    ///Mark: IBAction
    
    ///Mark: dismiss the view since segue is present modally from the last view
    @IBAction func haveaccount(_sender :Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    ///Mark: Register button
    @IBAction func registerbutton(_sender:Any){
        
        let username = userNameText.text
        let userEmail = userEmailtext.text
        let userPassword = userPasswordtext.text
        let userRepeatPassword = repeatPasswordtext.text
        guard let image = profileImageView.image else{return}
        
        
        if ( (username?.isEmpty)! || (userEmail?.isEmpty)! || (userPassword?.isEmpty)!||(userRepeatPassword?.isEmpty)!){

            displayMyAlertmessage(userMessage: "All fields are required")
            return
        }


        if(!(userEmail?.contains("@"))! || !(userEmail?.contains(".com"))!){
            displayMyAlertmessage(userMessage: "Password should be the email account")
        }

        if ( (userPassword?.count)! < 8){
            displayMyAlertmessage(userMessage: "Password should be more than 8 digits")
        }

        if(userPassword != userRepeatPassword){
            displayMyAlertmessage(userMessage: "Password not match")
        }
        
        ///Mark: FakeUser should be activated when executing UITest
        if let useFake = ProcessInfo.processInfo.environment["UseFakeUserService"], useFake == "true" {
            let fakeAppUser = FakeAppUser(identifier: "FakeUser")
            let fakeUserService = FakeUserService()
            fakeUserService.RegisterResultFakeUser = fakeAppUser
            userService = fakeUserService
            userService?.Register(email: userEmail!, password: userPassword!){user, error in
                if error == nil && user != nil{
                    print("user created")
                    self.displayMyAlertmessage(userMessage: "Registration is successful, Thank you")
                }
                else{
                    self.displayMyAlertmessage(userMessage: "Error sign in")
                }
            }
        }
            ///Mark: simply create the user account by setting useremail and password
        else{
        Auth.auth().createUser(withEmail: userEmail!, password: userPassword!){user, error in
            if error == nil && user != nil{
                print("user created")
                
                
                uploadProfileImage(image){url in
                    if url != nil{
                        let changedRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changedRequest?.displayName = username
                        changedRequest?.photoURL = url
                        changedRequest?.commitChanges{ error in
                            if error == nil{
                                print("User display name changed!")
                                
                                saveProfile(username: username!, profileImageURL: url!){ success in
                                    if success{
                                        self.dismiss(animated: true, completion: nil)
                                    }else{
                                        self.displayMyAlertmessage(userMessage: "Error sign in")
                                    }
                                }
                            }
                            else{
                                print("Error: \(error!.localizedDescription)")
                                self.displayMyAlertmessage(userMessage: "Error sign in")
                            }
                        }
                    }
                    else{
                        self.displayMyAlertmessage(userMessage: "Error sign in")
                    }
                }
                self.displayMyAlertmessage(userMessage: "Registration is Successful, Thank you")
            }
            else{
                self.displayMyAlertmessage(userMessage: "Error sign in")
            }
        }
        }
        ///Mark: let users to select the selfie they like
        func uploadProfileImage(_ image : UIImage,completion :@escaping ((_ url : URL?)->())){
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let storageRef = Storage.storage().reference().child("user/\(uid)")
            
            guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {return}
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storageRef.putData(imageData, metadata: metaData){metaData , error in
                if error == nil, metaData != nil{
                    storageRef.downloadURL{url, error in
                        if error != nil{
                            completion(nil)
                        }
                        else{
                            completion(url)
                        }
                    }
        
                }
                else{
                    completion(nil)
                }
            }
        }
        
        func saveProfile(username : String , profileImageURL:URL, completion : @escaping ((_ success: Bool)->())){
            guard let uid = Auth.auth().currentUser?.uid else{return}
            let databaseRef = Database.database().reference().child("users/profile/\(uid)")
            let userObject = [
                "username" : username,
                "photoURL" : profileImageURL.absoluteString
                ] as [String : Any]
            
            databaseRef.setValue(userObject){error, ref in
                completion(error == nil)
            }
        }
    }
    
    ///Mark: func for Alert create
    func displayMyAlertmessage(userMessage: String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
            
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
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
}

///Mark: ImagePicker and NavigationController delegate
extension registerView : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
    
    

