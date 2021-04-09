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
        //let service = Service()
        //service.getDataSet()
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
                    self.createPinToilettes(toilettes)
                } else {
                    self.toilettes = []
                }
            }
    }
    
    func createPinToilettes(_ toilettes: [Toilette]) {
        for toilette in toilettes {
            guard let geoPoint = toilette.fields.geo_point_2d else { return }
           
            let latitude = geoPoint[0]
            let longitude = geoPoint[1]
            print("latitude == \(latitude)", "longitude == \(longitude)")
            setupToilettesPin(latitude, longitude)
            
        }
        
    }
    
    func setupToilettesPin(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(pin)
    }

    @IBAction func listButton(_ sender: UIButton) {
    }
    
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.startUpdatingLocation()
            configureRegion(location)
        }
    }
    
    func configureRegion(_ location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let center = CLLocationCoordinate2D(latitude: 48.856614, longitude: 2.3522219)
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        setupUserPin(center)
    }
    
    func setupUserPin(_ center: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        mapView.addAnnotation(pin)
    }
    
}
