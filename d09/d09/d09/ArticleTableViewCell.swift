//
//  ArticleTableViewCell.swift
//  d09
//
//  Created by Claudio MUTTI on 10/12/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import cmutti2018

class ArticleTableViewCell: UITableViewCell {
    static var formatter = DateFormatter()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    var article: Article? {
        didSet {
            titleLabel.text = article?.title
            contentLabel.text = article?.content
            
            if let cDate = article?.create_date as Date?, let uDate = article?.update_date as Date? {
                createDateLabel.text = NSLocalizedString("Create date", comment: "") + ": \(ArticleTableViewCell.formatDate(date: cDate))"
                if cDate != uDate {
                    updateDateLabel.isEnabled = true
                    updateDateLabel.text = NSLocalizedString("Update date", comment: "") + ": \(ArticleTableViewCell.formatDate(date: uDate))"
                }
                else {
                    updateDateLabel.text = ""
                    updateDateLabel.isEnabled = false
                }
            }
            else {
                createDateLabel.text = ""
                createDateLabel.isEnabled = false
                updateDateLabel.text = ""
                updateDateLabel.isEnabled = false
            }
            
            if let imageData = article?.image as Data?, let myImage = UIImage(data: imageData) {
                articleImageView.image = myImage
            }
            else {
                articleImageView.image = UIImage(named: "noImage")
            }
        }
    }
    
    static private func formatDate(date: Date) -> String {
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}
