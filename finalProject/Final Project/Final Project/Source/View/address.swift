//
//  address.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit

///Mark: address cell
class address : UITableViewCell{
    var data: ProfileViewModelItem?{
        didSet{
            guard let data = data as? profileaddress else{
                return
            }
            label1.text = data.address
        }
    }
    @IBOutlet weak var label1: UILabel!
}
