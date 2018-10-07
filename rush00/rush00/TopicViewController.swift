//
//  TopicViewController.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var topicId: Int = 0
    var topicMessages = [TopicMessage]()
    
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
//            print(keyboardHeight)
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
//            print(keyboardHeight)
            self.view.frame.origin.y += keyboardHeight
        }
    }

    //Hide keyboard click btn return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if let message = textField.text, !message.isEmpty {
            textField.text = ""
            APIController.addMessage(to: topicId, message: message, action: {
                success, newData in
                if success, let newMessage = newData as? TopicMessage {
                    self.topicMessages.append(newMessage)                    
                    DispatchQueue.main.async {
                        self.messagesTable.reloadData()
                    }
                }
                return
            })
        }
        return true
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
