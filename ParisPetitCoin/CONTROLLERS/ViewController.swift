//
//  ViewController.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var toilettes = [Toilette]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManager()
        receiveData()
        mapView.delegate = self
    }
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()  //voir  func checkLocationAuthorization()/UserPosition App
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func receiveData() {
            let service = Service()
            service.getDataSet { [weak self] (statut, toilettes) in
                guard let self = self else { return }
                if statut {
                    guard let toilettes = toilettes else { return }
                    self.toilettes = toilettes
                    self.createPinToilette(toilettes)
                    
                } else {
                    self.toilettes = []
                }
            }
    }
    
    func createPinToilette(_ toilettes: [Toilette]) {
        for toilette in toilettes {
            guard let geoPoint = toilette.fields.geo_point_2d else { return }
            let latitude = geoPoint[0]
            let longitude = geoPoint[1]
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            guard let address = toilette.fields.adresse else { return }
            
            let pin = MapPin(title: address, locationName: "blabla", coordinate: coordinate)
            
            self.mapView.addAnnotation(pin)
        }
    }
    
    @IBAction func listButton(_ sender: UIButton) {
    }
    
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            configureRegion(location)
        }
    }
    
    func configureRegion(_ location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = "I'm Here"
        mapView.addAnnotation(pin)
        
    }
    
}

extension ViewController: MKMapViewDelegate {
 
//setup annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    //setup annotation
        guard annotation is MapPin else { return nil }
        
        let identifier = "MapPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    
    //setup annotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //add annotationView on annotation
            annotationView?.canShowCallout = true
            //add button on the right annotationView
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
            //indicate number of cumulate pins
            if #available(iOS 11.0, *) {
                annotationView!.clusteringIdentifier = ""
            } else {
                //
            }
            
        } else {
            annotationView?.annotation = annotation
        }
        //annotationView?.pinTintColor = .green
        annotationView?.image = UIImage(imageLiteralResourceName: "toiletteOpen")
        
        return annotationView
    }
}
 
