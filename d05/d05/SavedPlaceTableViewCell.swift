//
//  SavedPlaceTableViewCell.swift
//  d05
//
//  Created by Claudio MUTTI on 10/8/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit

class SavedPlaceTableViewCell: UITableViewCell {
    @IBOutlet weak var placeName: UILabel!
 
    var place: SavedPlace? {
        didSet {
            placeName.text = place?.name
        }
    }
}
