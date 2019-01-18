//
//  phone.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :profilephone class and responce ProfileViewModelItem protocol
class profilephone: ProfileViewModelItem{
    
    ///type
    var type: ProfileViewModeltemType{
        return .phone
    }
    
    ///sectionTitle
    var sectionTitle: String{
        return "Phone"
    }
    
    var phone :  String
    
    ///Initial class reference

    init(phone: String) {
        self.phone = phone
    }
    
}
