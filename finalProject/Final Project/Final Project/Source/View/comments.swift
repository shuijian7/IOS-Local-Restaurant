//
//  comments.swift
//  Final Project
//
//  Created by 张水鉴 on 8/7/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit

///Mark: comments cell
class comments : UITableViewCell{
    var data: ProfileViewModelItem?{
        didSet{
            guard let data = data as? profilecomments else{
                return
            }
            label1.text = data.comments
            label2.text = "see right now"
        }
    }
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
}
