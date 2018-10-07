//
//  TopicMessage.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation

class TopicMessage {
    var id : Int
    var userName : String
    var createDate : String
    var message : String
    var replies = [MessageReply]()
    
    init(id: Int, userName: String, createDate: String, message: String, replies: [MessageReply]) {
        self.id = id
        self.userName = userName
        self.createDate = createDate
        self.message = message
        self.replies = replies
    }
}
