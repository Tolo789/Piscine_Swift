//
//  Article+CoreDataClass.swift
//  
//
//  Created by Claudio MUTTI on 10/10/18.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {

    
    public var descriptionQ : String {
        get {
            "\"\(title)\" (Created at: \(create_date), language: \(language))\n\(content)\n\t(Last update: \(update_date))"
        }
    }
    
    public func toto() -> String {
        return "toto"
    }
}
