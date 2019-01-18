//
//  ProfileName.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :ProfileNameandpicture class and responce ProfileViewModelItem protocol
class ProfileNameandpicture: ProfileViewModelItem{
    ///type
    var type: ProfileViewModeltemType{
        return .nameandpicture
    }
    ///section
    var sectionTitle: String{
        return "Main Info"
    }
    
    
    var picture: String
    var name:String
    
    ///Initial class reference
    init(picture: String, name: String) {
        self.picture = picture
        self.name = name
    }
    
}
