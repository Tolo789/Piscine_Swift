//
//  ReplyTableViewCell.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    var reply : MessageReply? {
        didSet {
            userNameLabel?.text = reply?.userName
            dateLabel?.text = reply?.createDate
            replyLabel?.text = reply?.reply
        }
    }
}
