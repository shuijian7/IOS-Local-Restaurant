//
//  UserProfile.swift
//  Final Project
//
//  Created by 张水鉴 on 8/8/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :UserProfile class which handle the current user
class UserProfile{
    
    var uid : String
    var username : String
    var photoURL : URL
    
    ///Initial class reference
    init(uid:String, username:String,photoURL:URL){
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
