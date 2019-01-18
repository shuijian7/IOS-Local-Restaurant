//
//  datacollection.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation

///Enum for declaring different reference .type using in each cell
enum ProfileViewModeltemType{
    case nameandpicture
    case address
    case phone
    case menu
    case comments
}

///protol for type, rowCount which default is 1, sectionTitle
protocol ProfileViewModelItem {
    var type : ProfileViewModeltemType {get}
    var rowCount: Int{get}
    var sectionTitle:String{get}
    
}
extension ProfileViewModelItem{
    var rowCount: Int{
        return 1
    }
}
