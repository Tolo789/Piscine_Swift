//
//  Article+CoreDataProperties.swift
//  Pods
//
//  Created by Claudio MUTTI on 10/11/18.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var content: String?
    @NSManaged public var create_date: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var language: String?
    @NSManaged public var title: String?
    @NSManaged public var update_date: NSDate?

    override public var description: String {
        var str = ""
        str +=  "Title: \(title!)\n"
        str +=  "Content: \(content!)\n"
        str +=  "Language: \(language!)\n"
        str +=  "Create date: \(create_date!)\n"
        str +=  "Update date: \(update_date!)\n"
        return str
    }
}
