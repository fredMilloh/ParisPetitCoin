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
        
        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
    }
}
