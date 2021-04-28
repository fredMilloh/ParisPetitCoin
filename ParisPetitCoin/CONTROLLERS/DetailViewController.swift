//
//  DetailViewController.swift
//  ParisPetitCoin
//
//  Created by fred on 26/04/2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var selectedToilette: Toilette?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                     change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    func setupView() {
        progressView = UIProgressView(progressViewStyle: .default)
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let keyPath = #keyPath(WKWebView.estimatedProgress)
        webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        
        
        //guard
        if let item = selectedToilette {
            title = item.fields.type
            let url = URL(string: item.fields.url ?? "")
            
            webView.load(URLRequest(url: url!))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
