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
        
        APIController.currentView = self
        APIController.getTopicMessages(id: topicId) {
            success, data, totalElems in
            if success, let allTopics = data as? [TopicMessage] {
                self.topicMessages = allTopics
                DispatchQueue.main.async {
                    self.messagesTable.reloadData()
                }
            } else {
                self.displayAlert(message: "Cannot retrieve topic messages")
            }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("ok ")
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        print("***** keyboardWillShow *****")
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//            self.view.frame.origin.y -= keyboardHeight
//
//            //scroll bottom page
//            let scrollPoint = CGPoint(x: 0, y: self.messagesTable.contentSize.height - self.messagesTable.frame.size.height)
//            self.messagesTable.setContentOffset(scrollPoint, animated: false)
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        print("***** keyboardWillHide *****")
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//            self.view.frame.origin.y += keyboardHeight
//        }
//    }

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0, topicMessages[indexPath.row].userName == APIController.userLogin {
            let alertController = UIAlertController(title: "Confirm", message: "Do you want to delete this message ?", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
                //                    print("Closing delete");
                APIController.deleteMessage(messageId: self.topicMessages[indexPath.row].id) {
                    success, _ in
                    if success {
                        DispatchQueue.main.async {
                            self.topicMessages.remove(at: indexPath.row)
                            self.messagesTable.reloadData()
                        }
                    }
                }
            }
            alertController.addAction(closeAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
                //                    print("Closing cancel");
            }
            alertController.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
    
    func replyAdded(to messageId: Int, newReply: MessageReply) {
        for (i, message) in topicMessages.enumerated() {
            if message.id == messageId {
                topicMessages[i].replies.append(newReply)
                messagesTable.reloadData()
                break
            }
        }
    }
}
