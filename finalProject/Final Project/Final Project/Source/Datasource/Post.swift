//
//  Post.swift
//  Final Project
//
//  Created by 张水鉴 on 8/8/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :Post class for posts Array
class Post{
    
    var id:String
    var author : UserProfile
    var text : String
    var timestamp : Double
    var restaurant : String
    
    ///Initial class reference
    init(id: String, author:UserProfile,text:String,timestamp : Double,restaurant : String) {
        self.id = id
        self.author = author
        self.text = text
        self.timestamp = timestamp
        self.restaurant = restaurant
    }
}
