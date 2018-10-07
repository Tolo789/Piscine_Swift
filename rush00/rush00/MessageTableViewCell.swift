//
//  MessageTableViewCell.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var repliesTable: UITableView! {
        didSet {
            repliesTable.delegate = self
            repliesTable.dataSource = self
        }
    }
    
    // TODO: add action to add reply
    @IBOutlet weak var replyText: UITextField!

    var message : TopicMessage? {
        didSet {
            if let m = message {
                userNameLabel?.text = m.userName
                dateLabel?.text = m.createDate
                messageLabel?.text = m.message
                
                if let count = message?.replies.count {
                    let height: CGFloat = CGFloat(min(150, count * 75))
                    repliesTable.heightAnchor.constraint(equalToConstant: height).isActive = true
                } else {
                    repliesTable.heightAnchor.constraint(equalToConstant: 0).isActive = true
                }
            }
            repliesTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message?.replies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell") as! ReplyTableViewCell
        cell.reply = message?.replies[indexPath.row]
        return cell
    }
}
