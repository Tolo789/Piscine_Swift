//
//  PointOfInterest.swift
//  Plan42
//
//  Created by Jonathan DAVIN on 10/13/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import          Foundation
import          MapKit

class           PointOfInterest: NSObject
{
    var         name: String?
    var         location: CLLocationCoordinate2D?
    var         span: MKCoordinateSpan?
    let         annotation = MKPointAnnotation()
    
    init(name: String, description: String, location: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        self.name = name
        self.location = location
        self.span = span
        self.annotation.coordinate = location
        self.annotation.title = name
        self.annotation.subtitle = description
    }
    
    init(name: String) {
        self.name = name
    }
}
