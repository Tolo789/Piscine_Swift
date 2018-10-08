//
//  MessageTableViewCell.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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
    @IBOutlet weak var replyText: UITextField! {
        didSet {
            replyText.delegate = self
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        if let reply = replyText.text, !reply.isEmpty, let messageId = message?.id {
            replyText.text = ""
            APIController.addReply(to: messageId, reply: reply) {
                success, newData in
                if success, let newReply = newData as? MessageReply {
                    DispatchQueue.main.async {
                        // Delete prev constraint
//                        for constraint in self.repliesTable.constraints {
//                            guard constraint.firstAnchor == .heightAnchor else { continue }
//                            constraint.isActive = false
//                            break
//                        }
//                        if let count = self.message?.replies.count {
//                            let height: CGFloat = CGFloat(min(150, count * 75))
//                            self.repliesTable.heightAnchor.constraint(equalToConstant: height).isActive = false
//                        } else {
//                            self.repliesTable.heightAnchor.constraint(equalToConstant: 0).isActive = false
//                        }

                        // Add new constraint
//                        self.message?.replies.append(newReply)
                        if let vc = APIController.currentView as? TopicViewController {
                            vc.replyAdded(to: messageId, newReply: newReply)
                        }
//                        if let count = self.message?.replies.count {
//                            let height: CGFloat = CGFloat(min(150, count * 75))
//                            self.repliesTable.heightAnchor.constraint(equalToConstant: height).isActive = true
//                        } else {
//                            self.repliesTable.heightAnchor.constraint(equalToConstant: 0).isActive = true
//                        }
                    }
                }
                else {
                    if let vc = APIController.currentView as? TopicViewController {
                        vc.displayAlert(message: "Couldnt add reply")
                    }
                }
                return
            }
        }
        return true
    }
    
    var message : TopicMessage? {
        didSet {
            if let m = message {
                userNameLabel?.text = m.userName
                dateLabel?.text = m.createDate
                messageLabel?.text = m.message
                
//                if let count = message?.replies.count {
//                    let height: CGFloat = CGFloat(min(150, count * 75))
//                    repliesTable.heightAnchor.constraint(equalToConstant: height).isActive = true
//                } else {
//                    repliesTable.heightAnchor.constraint(equalToConstant: 0).isActive = true
//                }
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
