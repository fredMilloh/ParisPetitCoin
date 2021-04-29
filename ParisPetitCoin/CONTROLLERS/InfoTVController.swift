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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)

        cell.textLabel?.text = selectedToilette?.title
        cell.detailTextLabel?.text = selectedToilette?.adresse

        return cell
    }
   
}
