//
//  Toilette.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import Foundation

struct Toilette: Decodable {
    let fields: Fields
    
    enum CodingKeys: String, CodingKey {
        case fields = "fields"
    }
}

struct Fields: Decodable {
    let state: String?
    let arrondissement: String?
    let adresse: String?
    let geo_point_2d : [Double]?
    
    enum CodingKeys: String, CodingKey {
        case state = "statut"
        case arrondissement = "arrondissement"
        case adresse = "adresse"
        case geo_point_2d = "geo_point_2d"
    }
}



