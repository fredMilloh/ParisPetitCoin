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
                    self.createToiletteAnnotation(toilettes)
                    
                } else {
                    self.toilettes = []
                }
            }
    }
    
    func createToiletteAnnotation(_ toilettes: [Toilette]) {
        for toilette in toilettes {
            
            guard let geoPoint = toilette.fields.geo_point_2d else { return }
                let latitude = geoPoint[0]
                let longitude = geoPoint[1]
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let address = toilette.fields.adresse ?? ""
            let type = toilette.fields.type ?? ""
            let distrinct = toilette.fields.arrondissement ?? ""
            let accesPMR = toilette.fields.accesPMR ?? ""
            let horaire = toilette.fields.horaire ?? ""
            var horairs = horaire
            if horaire == KEY_FICHE {
                horairs = "select i for opening hours".localized()
            }
            let url = toilette.fields.url ?? ""
            let relaisBB = toilette.fields.relaisBB ?? ""
            var relais = ""
            if relaisBB == KEY_OUI { relais = "🚼" }
            var acces = "♿️"
            if accesPMR == "Non" { acces = "" }
            
            let annotation = ToiletteAnnotation(title: type, subtitle: horairs + " " + relais + " " + acces, coordinate: coordinate, url: url, arrondissement: distrinct, adresse: address, horaire: horaire, accesPMR: accesPMR, relais_bebe: relaisBB)
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func recenterMap(_ sender: UIButton) {
        guard let location = locationManager.location else { return }
        configureRegion(location)
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

        let userAnnotation = ToiletteAnnotation(title: KEY_ME, subtitle: "I'm Here 😉".localized(), coordinate: center, url: "", arrondissement: "", adresse: "", horaire: "", accesPMR: "", relais_bebe: "")
        mapView.addAnnotation(userAnnotation)
        
        mapView.showsCompass = true
        mapView.showsUserLocation = true
    }
}

extension ViewController: MKMapViewDelegate {
     
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "")
        if let annotation = annotation as? ToiletteAnnotation {
            
            //add bubble info on annotationView
            annotationView.canShowCallout = true
            
            //add button on the right annotationView
            let button = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = button
/*
            //indicate number of cumulate pins
            if #available(iOS 11.0, *) {
                annotationView.clusteringIdentifier = ""
            } else {
                annotationView.annotation = annotation
            }
*/
        switch annotation.title {
        case KEY_SANISETTES:
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = sanisettePin
        case KEY_URINOIR:
            annotationView.markerTintColor = .systemTeal
            annotationView.glyphImage = urinoirPin
        case KEY_URINOIRFEMME:
            annotationView.markerTintColor = .systemOrange
            annotationView.glyphImage = urinoirPin
        case KEY_TOILETTES:
            annotationView.markerTintColor = .systemYellow
            annotationView.glyphImage = toiletPin
        case KEY_WCPERM:
            annotationView.markerTintColor = .systemIndigo
            annotationView.glyphImage = toiletPin
        case KEY_LAVATORY:
            annotationView.markerTintColor = .systemGray
        case KEY_ME.localized():
            annotationView.markerTintColor = .systemBlue
            annotationView.glyphText = "😀"
        default:
            annotationView.markerTintColor = .systemTeal
            annotationView.glyphImage = questionMarkPin
        }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let toilette = view.annotation as? ToiletteAnnotation
        let infoTVC = self.storyboard?.instantiateViewController(identifier: INFOTVC) as! InfoTVController
        infoTVC.selectedToilette = toilette
        self.navigationController?.pushViewController(infoTVC, animated: true)
       
    }
}
 
