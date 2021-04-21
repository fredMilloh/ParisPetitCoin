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
            
            var status: String?
            let type = toilette.fields.type ?? ""
            let state = toilette.fields.state ?? ""
            
            switch type {
            case "SANISETTES":
                if state == KEY_OPEN {
                    status = KEY_SANIOPEN
                } else {
                    status = KEY_SANICLOSE
                }
            case "URINOIR MOBILE":
                if state == KEY_OPEN {
                    status = KEY_MOBURINOPEN
                } else {
                    status = KEY_MOBURINCLOSE
                }
            case "URINOIR":
                if state == KEY_OPEN {
                    status = KEY_URINOPEN
                } else {
                    status = KEY_URINCLOSE
                }
            case "CABINE MOBILE":
                if state == KEY_OPEN {
                    status = KEY_MOBCABINOPEN
                } else {
                    status = KEY_MOBCABINCLOSE
                }
            case "TOILETTES":
                status = KEY_TOILETTES
            default:
                status = ""
            }
            
            
            if type == "URINOIR" {
                print("type == \(type), state == \(state), adresse == \(address)")
            }
            
            let annotation = ToilettePin(title: address, subtitle: status, coordinate: coordinate)
            
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
        pin.subtitle = KEY_ME
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
        case KEY_SANIOPEN:
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = sanisette
        case KEY_SANICLOSE:
            annotationView.markerTintColor = .systemRed
            annotationView.glyphImage = sanisette
        case KEY_MOBURINOPEN:
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = urinoir
        case KEY_MOBURINCLOSE:
            annotationView.markerTintColor = .systemRed
            annotationView.glyphImage = urinoir
        case KEY_URINOPEN:
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = urinoir
        case KEY_URINCLOSE:
            annotationView.markerTintColor = .systemRed
            annotationView.glyphImage = urinoir
        case KEY_MOBCABINOPEN:
            annotationView.markerTintColor = .systemGreen
        case KEY_MOBCABINCLOSE:
            annotationView.markerTintColor = .systemRed
        case KEY_TOILETTES:
            annotationView.markerTintColor = .systemGray
            annotationView.glyphImage = toilet
        case KEY_ME:
            annotationView.markerTintColor = .systemBlue
            annotationView.glyphText = "😀"
        default:
            annotationView.markerTintColor = .systemTeal
            annotationView.glyphImage = questionMark
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let toilettePin = view.annotation as? ToilettePin else { return }
        
        //let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        toilettePin.mapItem?.openInMaps(launchOptions: launchOptions)
        
        
    }
}
 
