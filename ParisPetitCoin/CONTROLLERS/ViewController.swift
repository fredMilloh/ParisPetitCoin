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
    
    var toiletteSelected: Toilette?
    
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
            
            let type = toilette.fields.type ?? ""
            let distrinct = toilette.fields.arrondissement ?? ""
            let acces = toilette.fields.acces_pmr ?? ""
            let horaire = toilette.fields.horaire ?? ""
            let url = toilette.fields.url ?? ""
            let relaisBB = toilette.fields.relaisBB ?? ""
            
            let toiletteItem = Toilette(fields: Fields(arrondissement: distrinct, adresse: address, geo_point_2d: geoPoint, horaire: acces, type: horaire, acces_pmr: url, url: type, relaisBB: relaisBB))
            toiletteSelected = toiletteItem
            
            
            if type == "URINOIR FEMME" {
                print("type == \(type), adresse == \(address)")
            }
            
            let annotation = ToilettePin(title: type, subtitle: horaire, coordinate: coordinate)
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func detailToilette(_ toiletteSelected: Toilette) {
        
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
        pin.title = KEY_ME
        pin.subtitle = "I'm Here 😉"
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
            
        switch annotation.title {
        case KEY_SANISETTES:
            annotationView.markerTintColor = .systemGreen
            annotationView.glyphImage = sanisette
        case KEY_URINOIR:
            annotationView.markerTintColor = .systemTeal
            annotationView.glyphImage = urinoir
        case KEY_URINOIRFEMME:
            annotationView.markerTintColor = .systemOrange
            annotationView.glyphImage = urinoir
        case KEY_TOILETTES:
            annotationView.markerTintColor = .systemGray
            annotationView.glyphImage = toilet
        case KEY_LAVATORY:
            annotationView.markerTintColor = .systemYellow
        case KEY_WCPERM:
            annotationView.markerTintColor = .systemYellow
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
        
        let detailTableView = self.storyboard?.instantiateViewController(withIdentifier: "detailToilette") as! DetailTableVC
        self.toiletteSelected = detailTableView.toiletteDetail
        
        self.navigationController?.pushViewController(detailTableView, animated: true)
        
        /*
        guard let toilettePin = view.annotation as? ToilettePin else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        toilettePin.mapItem?.openInMaps(launchOptions: launchOptions)
        */
        
    }
}
 
