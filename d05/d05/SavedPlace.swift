//
//  SavedPlaces.swift
//  d05
//
//  Created by Claudio MUTTI on 10/8/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation
import UIKit

struct SavedPlace {
    var name: String = ""
    var description: String = ""
    var latitude: Double = 42.0
    var longitude: Double = 42.0
    var span: Double = 0.003
    var color: UIColor = UIColor.red
    
    init(name: String, description: String, latitude: Double, longitude: Double, span: Double, color: UIColor) {
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.span = span
        self.color = color
    }
    
    static var allPlaces: [SavedPlace] = [
        SavedPlace(name: "42", description: "Code", latitude: 48.896473, longitude: 2.318458, span: 0.003, color: UIColor.red),
        SavedPlace(name: "Parma", description: "Home", latitude: 44.803325, longitude: 10.330712, span: 3, color: UIColor.blue),
        SavedPlace(name: "BO2", description: "Sport", latitude: 48.911417, longitude: 2.324940, span: 0.04, color: UIColor.green)
    ]
}
