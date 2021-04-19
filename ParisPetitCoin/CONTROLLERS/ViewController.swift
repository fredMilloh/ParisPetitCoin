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
            guard let horaire = toilette.fields.horaire else { return }
            let state = toilette.fields.state ?? horaire
          
            guard let address = toilette.fields.adresse else { return }
            
            let annotation = ToilettePin(title: address, subtitle: state, coordinate: coordinate)
            
            self.mapView.addAnnotation(annotation)
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
        
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.subtitle = "me"
        pin.title = "I'm Here"
        mapView.addAnnotation(pin)
        
        mapView.showsCompass = true
        
        
    }
}

extension ViewController: MKMapViewDelegate {
     
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "")
        
            //add bubble info on annotationView
            annotationView.canShowCallout = true
            //add button on the right annotationView
        let button = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = button
            
            //indicate number of cumulate pins
            if #available(iOS 11.0, *) {
                annotationView.clusteringIdentifier = ""
            } else {
                annotationView.annotation = annotation
            }
        
        switch annotation.subtitle {
        case "Ouvert":
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = UIImage(named: "toilet50")
        case "Fermé":
            annotationView.markerTintColor = .systemRed
            annotationView.glyphImage = UIImage(named: "toilet50")
        case "me":
            annotationView.markerTintColor = .systemTeal
            annotationView.glyphText = "😀"
        default:
            annotationView.markerTintColor = .systemBlue
            annotationView.glyphImage = UIImage(named: "questionMark30")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let toilettePin = view.annotation as? ToilettePin else { return }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        toilettePin.mapItem?.openInMaps(launchOptions: launchOptions)
        
        
    }
}
 
