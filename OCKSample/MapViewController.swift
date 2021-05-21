//
//  MapViewController.swift
//  OCKSample
//
//  Created by Abigail Mortell on 11/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import MapKit
import UIKit

protocol HandleMapSearch {
    func dropPinZoomIn (placemark:MKPlacemark)
}

class MapViewController : UIViewController {

    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        map.showsUserLocation = true
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Mental health resources"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.map = map
        
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    @objc func getDirections () {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension MapViewController : CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error: \(error)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation]){
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            map.setRegion(region, animated: true)
            print("location: \(location)")
        }
    }

}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea{
            annotation.subtitle = "\(city) \(state)"
        }
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseId") as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.systemOrange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
