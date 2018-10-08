//
//  MessageReplies.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation

class MessageReply {
    var id : Int
    var userName : String
    var createDate : String
    var reply : String
    
    init(id: Int, userName: String, createDate: String, reply: String) {
        self.id = id
        self.userName = userName
        self.createDate = createDate
        self.reply = reply
    }
}
