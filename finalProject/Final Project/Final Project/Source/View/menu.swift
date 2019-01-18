//
//  menu.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit

///Mark: menu cell
class menu : UITableViewCell{
    var data: ProfileViewModelItem?{
        didSet{
            guard let data = data as? profilemenu else{
                return
            }
            label1.text = data.menu
            label2.text = "see right now"
        }
    }
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
}
