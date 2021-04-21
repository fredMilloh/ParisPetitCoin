//
//  ToilettePin.swift
//  ParisPetitCoin
//
//  Created by fred on 18/04/2021.
//

import Foundation
import MapKit
import Contacts

class ToilettePin: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    var mapItem: MKMapItem? {
        guard let location = title else { return nil }
        guard let state = subtitle else { return nil }
        
        let addressDict = [CNPostalAddressStreetKey: location, CNPostalAddressStateKey: state]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
    }
}
//Keys
let KEY_ME = "me"
let KEY_OPEN = "Ouvert"
let KEY_CLOSE = "Fermé"
let KEY_SANISETTES = "SANISETTES"
let KEY_SANIOPEN = "Open Sanisette"
let KEY_SANICLOSE = "Closed Sanisette"
let KEY_MOBURINOIR = "URINOIR MOBILE"
let KEY_MOBURINOPEN = "Open Mobile Urinal"
let KEY_MOBURINCLOSE = "Closed Mobile Urinal"
let KEY_URINOIR = "URINOIR"
let KEY_URINOPEN = "Open Urinal"
let KEY_URINCLOSE = "Closed Urinal"
let KEY_MOBCABIN = "CABINE MOBILE"
let KEY_MOBCABINOPEN = "Open Mobile Cabin"
let KEY_MOBCABINCLOSE = "Closed Mobile Cabin"
let KEY_TOILETTES = "TOILETTES"
let KEY_LAVATORY = "LAVATORY"
let KEY_WCPERM = "WC PUBLICS PERMANENTS"


//Images
let sanisette = UIImage(named: "sanisette")
let urinoir = UIImage(named: "man50")
let toilet = UIImage(named: "toilet50")
let questionMark = UIImage(named: "questionMark30")


