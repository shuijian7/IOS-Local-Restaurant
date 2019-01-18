//
//  UserService.swift
//  Final Project
//
//  Created by 张水鉴 on 8/8/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation
import Firebase

///Mark: UserService class
class UserService{
    
    ///static variable for handle current user
    static var currentUserProfile : UserProfile?
    
    ///func to observe current user from Firebase and optionally change the currentUserProfile
    static func observeUserProfile(_ uid: String, completion:@escaping ((_ UserProfile:UserProfile?)->())){
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile : UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoUrl = dict["photoURL"] as? String,
                let url = URL(string: photoUrl) {
                
                userProfile = UserProfile(uid: snapshot.key, username: username, photoURL:url)
            }
            completion(userProfile)
        })
    }
}
