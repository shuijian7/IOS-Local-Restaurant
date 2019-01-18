//
//  pictureAndname.swift
//  Final Project
//
//  Created by 张水鉴 on 8/3/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit

///Mark:pictureAndname cell
class pictureAndname : UITableViewCell{
    var data: ProfileViewModelItem? {
        didSet{
            guard let data = data as? ProfileNameandpicture else{
                return
        }
            label1.text = data.name
            imageview.image = UIImage(named: data.picture)
    }
}
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var label1: UILabel!
}
