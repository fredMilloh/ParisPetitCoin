//
//  InfoTVController.swift
//  ParisPetitCoin
//
//  Created by fred on 28/04/2021.
//

import UIKit
import WebKit

class InfoTVController: UITableViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var progressView: UIProgressView!
    
    var selectedToilette: ToiletteAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressView()
        setupWebView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func setupProgressView() {
        
        progressView = UIProgressView(progressViewStyle: .default)
        webView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let keyPath = #keyPath(WKWebView.estimatedProgress)
        webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
    }
    
    func setupWebView() {
        let url = selectedToilette?.url
        if url == "" {
            webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        } else {
            let urlToilette = URL(string: url!)
            webView.load(URLRequest(url: urlToilette!))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_HORAIRE, for: indexPath) as! LabelTVCell
            var horaire = selectedToilette?.horaire
            if horaire == "Voir fiche équipement" {
                horaire = "The opening hours are indicated on the website above"
                cell.infoLabel.text = horaire
            } else {
                cell.infoLabel.text = "The opening hours are  " + (horaire ?? "Indicated on the website above")
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_ADRESSE, for: indexPath) as! LabelTVCell
            let address = selectedToilette?.adresse
            cell.infoLabel.text = "Address : " + (address ?? "undefined")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_GO, for: indexPath) as! GoTVCell
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_TYPE, for: indexPath) as! LabelTVCell
            let type = selectedToilette?.title
            cell.infoLabel.text = "This toilet is type : " + (type ?? "undefined")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_ACCES, for: indexPath) as! LabelTVCell
            let acces = selectedToilette?.accesPMR
            if acces == "Oui" {
                cell.infoLabel.text = "♿️ Accessible to people with reduced mobility"
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_RELAIS, for: indexPath) as! LabelTVCell
            let relais = selectedToilette?.relais_bebe
            if relais == "Oui" {
                cell.infoLabel.text = "🚼  Relay baby"
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
   
}
