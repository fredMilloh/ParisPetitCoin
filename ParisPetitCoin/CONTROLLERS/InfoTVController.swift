//
//  InfoTVController.swift
//  ParisPetitCoin
//
//  Created by fred on 28/04/2021.
//

import UIKit
import WebKit
import MapKit

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
        progressView.bottomAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
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
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_HORAIRE, for: indexPath) as! LabelTVCell
            cell.iconImage.image = horlogeIcon
            var horaire = selectedToilette?.horaire
            let type = selectedToilette?.title
            if horaire == KEY_FICHE {
                horaire = "opening hours are indicated on the website above".localized()
                cell.infoLabel.text = horaire
            } else if horaire == "" {
                if type == KEY_LAVATORY {
                    cell.infoLabel.text = "opening hours are unknown".localized()
                } else if type == KEY_WCPERM {
                    cell.infoLabel.text = "opening hours are variable. About 9h00 am - 10h00 pm".localized()
                }
            } else {
                cell.infoLabel.text = "opening hours are".localized() + " " + (horaire ?? "unknow")
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_TYPE, for: indexPath) as! LabelTVCell
            let type = selectedToilette?.title
            cell.iconImage.image = typeIcon
            switch type {
            case KEY_LAVATORY:
                cell.infoLabel.text = "paid toilets".localized()
            case KEY_WCPERM:
                cell.infoLabel.text = "free mixed toilet. A person is present for all information.".localized()
            case KEY_URINOIRFEMME:
                cell.infoLabel.text = "free women's urinal".localized()
            case KEY_URINOIR:
                cell.infoLabel.text = "free men's urinal".localized()
            case KEY_TOILETTES:
                cell.infoLabel.text = "free mixed toilet".localized()
            case KEY_SANISETTES:
                cell.infoLabel.text = "free mixed toilet".localized()
            default:
                cell.infoLabel.text = "Undefined"
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_ACCES, for: indexPath) as! LabelTVCell
            cell.iconImage.image = disabledIcon
            let acces = selectedToilette?.accesPMR
            if acces == KEY_OUI {
                cell.infoLabel.text = "equipped for people with reduced mobility.".localized()
            } else {
                cell.infoLabel.text = "toilet without suitable equipment".localized()
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_ADRESSE, for: indexPath) as! LabelTVCell
            let address = selectedToilette?.adresse?.lowercased()
            let district = selectedToilette?.arrondissement
            cell.iconImage.image = addressIcon
            cell.infoLabel.text = (address ?? "undefined") + "  " + (district ?? "")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_GO, for: indexPath) as! GoTVCell
            cell.button = {
                guard let toiletteDestination = self.selectedToilette else { return }
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
                toiletteDestination.mapItem?.openInMaps(launchOptions: launchOptions)
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_RELAIS, for: indexPath) as! LabelTVCell
            let relais = selectedToilette?.relais_bebe
            if relais == KEY_OUI {
                cell.infoLabel.text = "🚼  Relay baby".localized()
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_IMAGE1, for: indexPath) as! ImageTVCell
            switch selectedToilette?.title {
            case KEY_SANISETTES:
                cell.imageToilette.image = sanisetteExt
            case KEY_TOILETTES:
                cell.imageToilette.image = toiletExt
            case KEY_WCPERM:
                cell.imageToilette.image = WcPublic1
            case KEY_URINOIR:
                cell.imageToilette.image = urinoirMan1
            case KEY_URINOIRFEMME:
                cell.imageToilette.image = urinoirWoman
            default:
                cell.imageToilette.image = UIImage()
            }
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_IMAGE2, for: indexPath) as! ImageTVCell
            switch selectedToilette?.title {
            case KEY_SANISETTES:
                cell.imageToilette.image = sanisetteInt
            case KEY_TOILETTES:
                cell.imageToilette.image = toiletInt
            case KEY_WCPERM:
                cell.imageToilette.image = WcPublic2
            case KEY_URINOIR:
                cell.imageToilette.image = urinoirMan2
            default:
                cell.imageToilette.image = UIImage()
            }
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_IMAGE3, for: indexPath) as! ImageTVCell
            switch selectedToilette?.title {
            case KEY_SANISETTES:
                cell.imageToilette.image = sanisetteButton
            default:
                cell.imageToilette.image = UIImage()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
   
}
extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
