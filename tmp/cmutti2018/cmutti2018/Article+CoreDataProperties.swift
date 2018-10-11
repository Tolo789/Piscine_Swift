//
//  Article+CoreDataProperties.swift
//  
//
//  Created by Claudio MUTTI on 10/10/18.
//
//

import Foundation
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var language: String?
    @NSManaged public var image: NSData?
    @NSManaged public var create_date: NSDate?
    @NSManaged public var update_date: NSDate?
}
