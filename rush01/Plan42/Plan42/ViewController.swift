//
//  ViewController.swift
//  Plan42
//
//  Created by Claudio MUTTI on 10/13/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, UISearchControllerDelegate, HandleMapSearch {

    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var selectedStartPin: MKPlacemark? = nil
    var alert: UIAlertController!
    var isCustomStart = false
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var transportTypeSeg: UISegmentedControl!
    @IBAction func transportTypeSeg(_ sender: Any) {
        if let sel = selectedPin {
            mapView.removeOverlays(mapView.overlays)
            let start = (selectedStartPin == nil) ? (locationManager.location?.coordinate) : (selectedStartPin?.location?.coordinate )
            guard let startSafe = start, let toGo = sel.location?.coordinate else { return }
            drawDirection(startSafe, toGo)
        }
        
    }
    
    @IBAction func focusMeButton(_ sender: Any) {
        guard let coord = locationManager.location?.coordinate else { return }
        zoomToLocation(with: coord)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupMapView()
        setupSearchBar()
        setupSeg()
    }
    
    func            push_notification_alert_error(title: String, message: String, buttonTitle: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: {})
    }
    
    func drawDirection(_ startingCoordinates: CLLocationCoordinate2D, _ toCoordinates: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: startingCoordinates)
        let destPlacemark = MKPlacemark(coordinate: toCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        switch transportTypeSeg.selectedSegmentIndex {
        case 0:
            directionRequest.transportType = .automobile
        case 1:
            directionRequest.transportType = .walking
        case 2:
            directionRequest.transportType = .transit
        default:
            directionRequest.transportType = .automobile
        }
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    self.push_notification_alert_error(title: "Oops..", message: "We don't have any suitable data for transit in your region yet", buttonTitle: "Arf..")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            var rect = route.polyline.boundingMapRect
            rect.size.height = rect.size.height * 1.2
            rect.size.width = rect.size.width * 1.2
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    private func        zoomToLocation(with coordinate: CLLocationCoordinate2D)
    {
        let             span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let             region:MKCoordinateRegion = MKCoordinateRegion(center: (locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)), span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 70/255, green: 140/255, blue: 241/255, alpha: 1)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "navigation_icon"), for: .normal)
        button.addTarget(self, action: #selector(askStartDirection), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1.5
        longPress.delegate = self
        mapView.addGestureRecognizer(longPress)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func setupSeg() {
        transportTypeSeg.backgroundColor = .white
        transportTypeSeg.layer.masksToBounds = true
        transportTypeSeg.layer.cornerRadius = transportTypeSeg.frame.height / 2
        transportTypeSeg.layer.borderWidth = 1
        transportTypeSeg.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1.0, alpha: 1).cgColor

        transportTypeSeg.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)

        transportTypeSeg.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .selected)
    }
    
    func setupSearchBar() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        //  Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        resultSearchController?.delegate = self
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        isCustomStart = false
        selectedStartPin = nil
    }
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        mapView.removeOverlays(mapView.overlays)
        
        // cache the pin
        if isCustomStart {
            selectedStartPin = placemark
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
            
            getDirections()
        }
        else {
//            selectedStartPin = nil
            selectedPin = placemark
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
        
        isCustomStart = false
    }
    
    @objc func askStartDirection() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Start Choice", message: "Which starting point would you like to choose ?", preferredStyle: .alert)
            
            let userAction = UIAlertAction(title: "My Position", style: .default) { (action:UIAlertAction) in
                self.isCustomStart = false
                self.selectedStartPin = nil
                self.getDirections()
            }
            alert.addAction(userAction)
            let customDirectionAction = UIAlertAction(title: "Search", style: .default) { (action:UIAlertAction) in
                self.isCustomStart = true
                self.resultSearchController?.searchBar.becomeFirstResponder()
            }
            alert.addAction(customDirectionAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func getDirections() {
        if let selectedPin = selectedPin {
            let start = (selectedStartPin == nil) ? locationManager.location?.coordinate : selectedStartPin?.location?.coordinate
            guard let startSafe = start, let toGo = selectedPin.location?.coordinate else { return }
            drawDirection(startSafe, toGo)
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer?) {
        if gestureRecognizer?.state == .began {
            isCustomStart = false
            selectedStartPin = nil
            let coordinate: CLLocationCoordinate2D = mapView.convert(gestureRecognizer?.location(in: mapView) ?? CGPoint.zero, toCoordinateFrom: mapView)
            
            mapView.setCenter(coordinate, animated: true)
            
            // Do anything else with the coordinate as you see fit in your application
            var myDictionary = [String: Any]()
            myDictionary["Name"] = "My Target"
            let clickedPlace = MKPlacemark(coordinate: coordinate, addressDictionary: myDictionary)
            
            dropPinZoomIn(placemark: clickedPlace)
        }
    }
}

extension ViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}
