//
//  FirstViewController.swift
//  d05
//
//  Created by Claudio MUTTI on 10/8/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    enum mapType: Int {
        case standardMap = 0
        case satelliteMap = 1
        case hybridMap = 2
    }
    
    var consumableSavedPlace: SavedPlace? = SavedPlace.allPlaces[0]
    
    let userSpan = MKCoordinateSpanMake(0.005, 0.005)
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if let requestedType = (sender as AnyObject).selectedSegmentIndex {
            switch requestedType {
                case mapType.standardMap.rawValue:
                    mapView.mapType = .standard
                case mapType.satelliteMap.rawValue:
                    mapView.mapType = .satellite
                case mapType.hybridMap.rawValue:
                    mapView.mapType = .hybrid
                default:
                    break
            }
        }
    }
    @IBAction func localizeUser(_ sender: UIButton) {
        if let coord = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: coord, span: userSpan)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request Location auth
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        
        // Add pins to map
        for place in SavedPlace.allPlaces {
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = place.name
            annotation.subtitle = place.description
            mapView.addAnnotation(annotation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If any, focus on SavedPlace
        if let consumable = consumableSavedPlace {
            let centerCoordinate = CLLocationCoordinate2D(latitude: consumable.latitude, longitude: consumable.longitude)
            let tmpSpan = MKCoordinateSpanMake(consumable.span, consumable.span)
            let region = MKCoordinateRegion(center: centerCoordinate, span: tmpSpan)
            mapView.setRegion(region, animated: true)
            
            // Consume
            consumableSavedPlace = nil
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        // Instantiate pin only if cannot reuse one that is not currently displayed
        var annotationView: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation")
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        }
        else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        }
        
        // Change color
        if let name = annotation.title, let place = SavedPlace.allPlaces.first(where: {return $0.name == name} ) {
            annotationView.pinTintColor = place.color  //annotation.title
        }
        
        return annotationView
    }

}

