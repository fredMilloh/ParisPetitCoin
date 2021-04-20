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
                if state == "Ouvert" {
                    status = "SOuvert"
                } else {
                    status = "SFermé"
                }
            case "URINOIR MOBILE":
                if state == "Ouvert" {
                    status = "UMOuvert"
                } else {
                    status = "UMFermé"
                }
            case "URINOIR":
                if state == "Ouvert" {
                    status = "UOuvert"
                } else {
                    status = "UFermé"
                }
            case "CABINE MOBILE":
                if state == "Ouvert" {
                    status = "CMOuvert"
                } else {
                    status = "CMFermé"
                }
            case "TOILETTES":
                status = "toilettes"
            default:
                status = ""
            }
            
            /*
            if type == "URINOIR MOBILE" {
                print("type == \(type), state == \(state), url == \(url), horaire == \(horaire), adresse == \(address)")
            }
            */
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
        case "SOuvert":
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = UIImage(named: "toilet50")
        case "SFermé":
            annotationView.markerTintColor = .systemRed
            annotationView.glyphImage = UIImage(named: "toilet50")
        case "UMOuvert":
            annotationView.markerTintColor = .systemGreen
        case "UMFermé":
            annotationView.markerTintColor = .systemRed
        case "UOuvert":
            annotationView.markerTintColor = .systemGreen
        case "UFermé":
            annotationView.markerTintColor = .systemRed
        case "CMOuvert":
            annotationView.markerTintColor = .systemGreen
        case "CMFermé":
            annotationView.markerTintColor = .systemRed
        case "toilettes":
            annotationView.markerTintColor = .systemGray
        case "me":
            annotationView.markerTintColor = .systemBlue
            annotationView.glyphText = "😀"
        default:
            annotationView.markerTintColor = .systemTeal
            annotationView.glyphImage = UIImage(named: "questionMark30")
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
 
