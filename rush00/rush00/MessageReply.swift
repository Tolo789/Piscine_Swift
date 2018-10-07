//
//  MessageReplies.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation

class MessageReply {
    var userName : String
    var createDate : String
    var reply : String
    
    init(userName: String, createDate: String, reply: String) {
        self.userName = userName
        self.createDate = createDate
        self.reply = reply
    }
}
