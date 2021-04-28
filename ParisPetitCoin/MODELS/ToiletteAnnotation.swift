//
//  ToiletteAnnotation.swift
//  ParisPetitCoin
//
//  Created by fred on 18/04/2021.
//

import Foundation
import MapKit
import Contacts

class ToiletteAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let url: String?
    let arrondissement: String?
    let adresse: String?
    let horaire: String?
    let accesPMR: String?
    let relais_bebe: String?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, url: String?, arrondissement: String?, adresse: String?, horaire: String?, accesPMR: String?, relais_bebe: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.url = url
        self.arrondissement = arrondissement
        self.adresse = adresse
        self.horaire = horaire
        self.accesPMR = accesPMR
        self.relais_bebe = relais_bebe
        
        super.init()
    }
    
    var mapItem: MKMapItem? {
        guard let location = title else { return nil }
       // guard let location = coordinate else { return nil }
        guard let type = subtitle else { return nil }
        
        let addressDict = [CNPostalAddressStreetKey: location, CNPostalAddressStateKey: type]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
    }
}
//Keys
let KEY_ME = "me"
let KEY_SANISETTES = "SANISETTE"
let KEY_URINOIR = "URINOIR"
let KEY_URINOIRFEMME = "URINOIR FEMME"
let KEY_TOILETTES = "TOILETTES"
let KEY_LAVATORY = "LAVATORY"
let KEY_WCPERM = "WC PUBLICS PERMANENTS"


//Images
let sanisette = UIImage(named: "sanisette")
let urinoir = UIImage(named: "man50")
let toilet = UIImage(named: "toilet50")
let questionMark = UIImage(named: "questionMark30")


