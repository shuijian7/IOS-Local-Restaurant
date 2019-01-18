//
//  profilecomments.swift
//  Final Project
//
//  Created by 张水鉴 on 8/7/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :profilecomments class and responce ProfileViewModelItem protocol
class profilecomments: ProfileViewModelItem{
    
    ///type
    var type: ProfileViewModeltemType{
        return .comments
    }
    
    ///sectionTitle
    var sectionTitle: String{
        return "Comments"
    }
    
    var comments : String
    
    ///Initial class reference
    init(comments:String) {
        self.comments = comments
    }
    
}
