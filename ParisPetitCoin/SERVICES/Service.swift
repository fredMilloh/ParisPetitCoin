//
//  Service.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import Foundation
import Alamofire

class Service {
    
    fileprivate var baseUrl = KEY_Url
    
    typealias toilettesCallBack = (_ statut: Bool, _ toilettes: [Toilette]?) -> Void
    
    func getDataSet(callback: @escaping toilettesCallBack) {
        
        AF.request(self.baseUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
            .response { (responseData) in
            guard let dataIn = responseData.data else {
                callback(false, nil)
                return }
                    do {
                        let toilettes = try JSONDecoder().decode([Toilette].self, from: dataIn)
                        callback(true, toilettes)
                    } catch {
                        callback(false, nil)
                    }
            }
    }
}
