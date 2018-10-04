//
//  APITwitterDelegate.swift
//  d04
//
//  Created by Claudio MUTTI on 10/4/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation

protocol APITwitterDelegate {
    func treatTweets(tweets: [Tweet])
    func handleError(error: NSError)
}
