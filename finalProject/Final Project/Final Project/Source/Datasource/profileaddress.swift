//
//  profileaddress.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :profileaddress class and responce ProfileViewModelItem protocol
class profileaddress: ProfileViewModelItem{
    ///type
    var type: ProfileViewModeltemType{
        return .address
    }
    
    ///sectionTitle
    var sectionTitle: String{
        return "Address"
    }
    
    var address: String
    
    ///Initial class reference
    init(address: String) {
        self.address = address
    }
    
}
