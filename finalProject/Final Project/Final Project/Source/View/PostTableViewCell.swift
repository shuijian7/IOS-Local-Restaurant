//
//  PostTableViewCell.swift
//  Final Project
//
//  Created by 张水鉴 on 8/7/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit

///Mark: PostTableViewCell XIB custom cell
class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        postTextLabel.accessibilityIdentifier = "Thumb up"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///Mark: Set label and imageView
    func set(post:Post){
        ImageService.getImage(withURL: post.author.photoURL){ image in
            self.profileImageView.image = image
        }
        usernameLabel.text = post.author.username
        postTextLabel.text = post.text
        
        let timestampDate = NSDate(timeIntervalSince1970: post.timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        subtitleLabel.text = "Updated at" + " " + dateFormatter.string(from: timestampDate as Date)
        }
    
    
    
}
