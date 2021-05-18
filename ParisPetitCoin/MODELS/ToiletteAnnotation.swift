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
    let relaisBebe: String?

    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D,
         url: String?,
         arrondissement: String?,
         adresse: String?,
         horaire: String?,
         accesPMR: String?,
         relaisBebe: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.url = url
        self.arrondissement = arrondissement
        self.adresse = adresse
        self.horaire = horaire
        self.accesPMR = accesPMR
        self.relaisBebe = relaisBebe

        super.init()
    }

    var mapItem: MKMapItem? {
        guard let location = adresse else { return nil }

        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
    }
}
