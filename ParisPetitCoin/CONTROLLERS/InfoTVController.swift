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
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
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
            return setupHoraire(tableView, cellForRowAt: indexPath)
        case 1:
            return setupType(tableView, cellForRowAt: indexPath)
        case 2:
            return setupAcces(tableView, cellForRowAt: indexPath)
        case 3:
           return setupAdresse(tableView, cellForRowAt: indexPath)
        case 4:
            return setupGo(tableView, cellForRowAt: indexPath)
        case 5:
            return setupRelais(tableView, cellForRowAt: indexPath)
        case 6:
           return setupImage1(tableView, cellForRowAt: indexPath)
        case 7:
            return setupImage2(tableView, cellForRowAt: indexPath)
        case 8:
           return setupImage3(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }

    func setupHoraire(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabelTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idHoraire,
                                                       for: indexPath) as? LabelTVCell else {
                                                        return LabelTVCell() }
        cell.iconImage.image = horlogeIcon
        var horaire = selectedToilette?.horaire
        let type = selectedToilette?.title
        if horaire == keyFiche {
            horaire = "opening hours are indicated on the website above".localized()
            cell.infoLabel.text = horaire
        } else if horaire == "" {
            if type == keyLavatory {
                cell.infoLabel.text = "opening hours are unknown".localized()
            } else if type == keyWcPerm {
                cell.infoLabel.text = "opening hours are variable. About 9h00 am - 10h00 pm".localized()
            }
        } else {
            cell.infoLabel.text = "opening hours are".localized() + " " + (horaire ?? "unknow")
        }
        return cell
    }

    func setupType(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabelTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idType,
                                                       for: indexPath) as? LabelTVCell else {
                                                        return LabelTVCell() }
        let type = selectedToilette?.title
        cell.iconImage.image = typeIcon
        switch type {
        case keyLavatory:
            cell.infoLabel.text = "paid toilets".localized()
        case keyWcPerm:
            cell.infoLabel.text = "free mixed toilet. A person is present for all information.".localized()
        case keyUrinoirFemme:
            cell.infoLabel.text = "free women's urinal".localized()
        case keyUrinoir:
            cell.infoLabel.text = "free men's urinal".localized()
        case keyToilettes:
            cell.infoLabel.text = "free mixed toilet".localized()
        case keySanisettes:
            cell.infoLabel.text = "free mixed toilet".localized()
        default:
            cell.infoLabel.text = "Undefined"
        }
        return cell
    }

    func setupAcces(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabelTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idAcces,
                                                       for: indexPath) as? LabelTVCell else {
                                                        return LabelTVCell() }
        cell.iconImage.image = disabledIcon
        let acces = selectedToilette?.accesPMR
        if acces == keyOui {
            cell.infoLabel.text = "equipped for people with reduced mobility.".localized()
        } else {
            cell.infoLabel.text = "toilet without suitable equipment".localized()
        }
        return cell
    }

    func setupAdresse(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabelTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idAdresse,
                                                       for: indexPath) as? LabelTVCell else {
                                                        return LabelTVCell() }
        let address = selectedToilette?.adresse?.lowercased()
        let district = selectedToilette?.arrondissement
        cell.iconImage.image = addressIcon
        cell.infoLabel.text = (address ?? "undefined") + "  " + (district ?? "")
        return cell
    }

    func setupGo(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> GoTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idGo,
                                                       for: indexPath) as? GoTVCell else {
                                                        return GoTVCell() }
        cell.button = {
            guard let toiletteDestination = self.selectedToilette else { return }
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            toiletteDestination.mapItem?.openInMaps(launchOptions: launchOptions)
        }
        return cell
    }

    func setupRelais(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LabelTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idRelais,
                                                       for: indexPath) as? LabelTVCell else {
                                                        return LabelTVCell() }
        let relais = selectedToilette?.relaisBebe
        if relais == keyOui {
            cell.infoLabel.text = "🚼  Relay baby".localized()
        }
        return cell
    }

    func setupImage1(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ImageTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idImage1,
                                                       for: indexPath) as? ImageTVCell else {
                                                        return ImageTVCell() }
        switch selectedToilette?.title {
        case keySanisettes:
            cell.imageToilette.image = sanisetteExt
        case keyToilettes:
            cell.imageToilette.image = toiletExt
        case keyWcPerm:
            cell.imageToilette.image = wcPublic1
        case keyUrinoir:
            cell.imageToilette.image = urinoirMan1
        case keyUrinoirFemme:
            cell.imageToilette.image = urinoirWoman
        default:
            cell.imageToilette.image = UIImage()
        }
        return cell
    }

    func setupImage2(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ImageTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idImage2,
                                                       for: indexPath) as? ImageTVCell else {
                                                        return ImageTVCell() }
        switch selectedToilette?.title {
        case keySanisettes:
            cell.imageToilette.image = sanisetteInt
        case keyToilettes:
            cell.imageToilette.image = toiletInt
        case keyWcPerm:
            cell.imageToilette.image = wcPublic2
        case keyUrinoir:
            cell.imageToilette.image = urinoirMan2
        default:
            cell.imageToilette.image = UIImage()
        }
        return cell
    }

    func setupImage3(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ImageTVCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idImage3,
                                                       for: indexPath) as? ImageTVCell else {
                                                        return ImageTVCell() }
        switch selectedToilette?.title {
        case keySanisettes:
            cell.imageToilette.image = sanisetteButton
        default:
            cell.imageToilette.image = UIImage()
        }
        return cell
    }
}
