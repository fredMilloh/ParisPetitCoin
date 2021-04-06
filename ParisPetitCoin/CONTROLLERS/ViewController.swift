//
//  ViewController.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //https://www.data.gouv.fr/fr/datasets/r/9cf8fab8-997c-4814-9600-8c17bc3de7e0

    override func viewDidLoad() {
        super.viewDidLoad()
    let service = Service(baseUrl: "https://www.data.gouv.fr/fr/datasets/r/9cf8fab8-997c-4814-9600-8c17bc3de7e0")
        service.getDataSet()
    }


}

