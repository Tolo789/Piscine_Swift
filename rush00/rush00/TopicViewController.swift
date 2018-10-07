//
//  TopicViewController.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var topicId: Int = 0
    var topicMessages = [TopicMessage]()
    
    @IBOutlet weak var messagesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: fetch messages
//        var replies = [MessageReply]()
//        topicMessages.append(TopicMessage(id: 0, userName: "Me", createDate: "yesterday", message: "Noov", replies: replies))

//        replies = [MessageReply]()
//        replies.append(MessageReply(userName: "Test", createDate: "Dunno", reply: "."))
//        replies.append(MessageReply(userName: "Test", createDate: "Dunno", reply: "."))
//        topicMessages.append(TopicMessage(id: 0, userName: "Me2", createDate: "yesterday", message: "Noob", replies: replies))
//
//        replies = [MessageReply]()
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "It's me.."))
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "..\n\n\n\n MARIO !!"))
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "..\n\n\n\n MARIO !!"))
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "..\n\n\n\n MARIO !!"))
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "..\n\n\n\n MARIO !!"))
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "..\n\n\n\n MARIO !!"))
//        replies.append(MessageReply(userName: "Reply", createDate: "Dunno", reply: "..\n\n\n\n MARIO !!"))
//        topicMessages.append(TopicMessage(id: 0, userName: "Me3", createDate: "yesterday", message: "n00b", replies: replies))
//
//        replies = [MessageReply]()
//        topicMessages.append(TopicMessage(id: 0, userName: "Me4", createDate: "yesterday", message: "Noob!", replies: replies))
//
//        messagesTable.reloadData()
        
        APIController.currentView = self
        APIController.getTopicMessages(id: topicId) {
            success, data, totalElems in
            if success, let allTopics = data as? [TopicMessage] {
                self.topicMessages = allTopics
                DispatchQueue.main.async {
                    self.messagesTable.reloadData()
                }
            }
            else {
                self.displayAlert(message: "Cannot retrieve topic messages")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageTableViewCell
        cell.message = topicMessages[indexPath.row]
        return cell
    }
    
    func displayAlert(title: String = "Error", message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("Closing alert");
            }
            alertController.addAction(closeAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
