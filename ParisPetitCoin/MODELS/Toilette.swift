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
    let geo_point_2d: [Double]?
    let acces_pmr: String?
    let horaire: String?
    let url: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case state = "statut"
        case arrondissement = "arrondissement"
        case adresse = "adresse"
        case geo_point_2d = "geo_point_2d"
        case acces_pmr = "acces_pmr"
        case horaire = "horaire"
        case url = "url_fiche_equipement"
        case type = "type"
    }
}

let KEY_OPEN = "Ouvert"
let KEY_CLOSE = "Fermé"
let KEY_SANIOPEN = "Open Sanisette"
let KEY_SANICLOSE = "Closed Sanisette"
let KEY_MOBURINOPEN = "Open Mobile Urinal"
let KEY_MOBURINCLOSE = "Closed Mobile Urinal"
let KEY_URINOPEN = "Open Urinal"
let KEY_URINCLOSE = "Closed Urinal"
let KEY_MOBCABINOPEN = "Open Mobile Cabin"
let KEY_MOBCABINCLOSE = "Closed Mobile Cabin"
let KEY_TOILETTES = "toilettes"
    

