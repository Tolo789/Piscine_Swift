//
//  TopicGenerals.swift
//  rush00
//
//  Created by Claudio MUTTI on 10/5/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation

class Topic {
    var userName : String
    var createDate : String
    var topicTitle : String
    var id : Int
    
    init(userName: String, createDate: String, topicTitle: String, id: Int) {
        self.userName = userName
        self.createDate = createDate
        self.topicTitle = topicTitle
        self.id = id
    }
}
