//
//  TweetTableViewCell.swift
//  MetroTweet
//
//  Created by Emiko Clark on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var metroID: UIImageView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
