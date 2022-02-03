//
//  DUWebViewController.swift
//  DriveUAssignment
//
//  Created by Ankit Jain on 03/02/22.
//

import UIKit
import WebKit

class DUWebViewController: UIViewController {
    // Add here outlets
    var webView: WKWebView!

    // Add here your view model
    lazy var viewModel: DUWebViewModel = {
        return DUWebViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() {
        // Add here the setup for the UI
        // Show loading indicator till Webview loads
        DUSpinner.singleton.showIndicator()
        setupNavigationBar()
        
        navigationController?.navigationBar.isTranslucent = false

        if let featureModel = viewModel.featureModel, let redirectURL = featureModel.redirectURL, let url = URL(string: redirectURL) {
            // Do any additional setup after loading the view.
            webView = WKWebView()
            webView.navigationDelegate = self
            webView.scrollView.delegate = self
            view = webView

            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.hidesBackButton = true
        
        let cancel = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(cancelAction))
        cancel.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        navigationItem.leftBarButtonItem = cancel
        navigationItem.leftBarButtonItem?.tintColor = .themeBlue
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated:true)
    }
}

extension DUWebViewController: WKNavigationDelegate, UIScrollViewDelegate {
    // Disable User selection
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DUSpinner.singleton.hideIndicator() // Hide the loader
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DUSpinner.singleton.hideIndicator() // Hide the loader
    }
}
