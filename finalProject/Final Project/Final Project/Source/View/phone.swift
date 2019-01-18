//
//  phone.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit

///Mark: phone cell
class phone : UITableViewCell{
    var data: ProfileViewModelItem?{
        didSet{
            guard let data = data as? profilephone else{
                return
            }
            label1.text = data.phone
            label2.text = "call right now"
        }
    }
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
}
