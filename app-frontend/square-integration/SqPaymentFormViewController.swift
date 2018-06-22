//
//  SqPaymentFormViewController.swift
//  square-integration
//
//  Created by steven freed on 6/19/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit
import WebKit

protocol nonceDelegate: class {
    func getNonce(nonce: String?)
}

class SqPaymentFormViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {

    weak var delegate: nonceDelegate?
    weak var webView: WKWebView!
    
    // MARK: - Configures and launches WebView of SqPaymentForm.
    //      Square's SqPaymentForm currently is not available for
    //      Swift or Objective-C client so you must use a webview
    //      for any Square integrations where you need to obtain
    //      a 'card_nonce' or 'card_id' for a payment method.
    func addCard()
    {
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        
        controller.add(self, name: "nonceListener")
        configuration.userContentController = controller
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.view = self.webView
        
        // * NOTE: - You need a webpage to host the html code as it will
        //          not run if you drag it into Xcode. I would suggest making
        //          a static webpage using AWS S3 bucket. This way there is no
        //          need for a server.
        let url = URL(string: "https://myWebsite.com/index.html")!
        let request = URLRequest(url: url)
        self.webView.load(request)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCard()
        
    }
    
    // MARK: - Listens for the 'messageHandler' for 'nonceListener' in index.html script
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.body as? String) != nil
        {
            self.delegate?.getNonce(nonce: message.body as! String)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
