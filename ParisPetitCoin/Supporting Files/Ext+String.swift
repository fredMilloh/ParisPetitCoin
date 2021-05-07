//
//  Ext+String.swift
//  ParisPetitCoin
//
//  Created by fred on 07/05/2021.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
