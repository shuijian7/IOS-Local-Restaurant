//
//  menu.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Mark :profilemenu class and responce ProfileViewModelItem protocol
class profilemenu: ProfileViewModelItem{
    ///type
    var type: ProfileViewModeltemType{
        return .menu
    }
    
    ///sectionTitle
    var sectionTitle: String{
        return "Menu"
    }
    
    var menu : String
    
    ///Initial class reference
    init(menu:String) {
        self.menu = menu
    }
    
}
