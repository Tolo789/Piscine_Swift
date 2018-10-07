//
//  TopicTableViewCell.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topicNameLabel: UILabel!
    
    var topic : Topic? {
        didSet {
            userNameLabel?.text = topic?.userName
            dateLabel?.text = topic?.createDate
            topicNameLabel?.text = topic?.topicTitle
        }
    }
}
