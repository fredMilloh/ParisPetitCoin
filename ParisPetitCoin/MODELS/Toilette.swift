//
//  Toilette.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import Foundation

struct Toilette: Decodable {
    let statut: String?
    let arrondissement: String?
    let adresse: String?

    
    enum CodingKeys: String, CodingKey {
        case statut = "statut"
        case arrondissement = "arrondissement"
        case adresse = "adresse"
        
    }
}

