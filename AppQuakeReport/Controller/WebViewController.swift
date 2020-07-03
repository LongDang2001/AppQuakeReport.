//
//  ViewController.swift
//  AppQuakeReport
//
//  Created by admin on 5/26/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var urlOfRow = ""
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        if let url = URL(string: urlOfRow) {
            webView.load(URLRequest(url: url))
        }
    }
}

