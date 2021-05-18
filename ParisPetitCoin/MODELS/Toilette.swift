//
//  Toilette.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import Foundation

struct Toilette: Decodable {
    let fields: Fields
}

struct Fields: Decodable {
    let arrondissement: String?
    let adresse: String?
    let geoPoint: [Double]?
    let horaire: String?
    let type: String?
    let accesPMR: String?
    let url: String?
    let relaisBB: String?

    enum CodingKeys: String, CodingKey {
        case arrondissement = "arrondissement"
        case adresse = "adresse"
        case geoPoint = "geo_point_2d"
        case accesPMR = "acces_pmr"
        case horaire = "horaire"
        case url = "url_fiche_equipement"
        case type = "type"
        case relaisBB = "relais_bebe"
    }
}
