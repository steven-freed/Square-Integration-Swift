//
//  CreateOrderViewController.swift
//  square-integration
//
//  Created by steven freed on 6/19/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit

class CreateOrderViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var responseView: UITextView!
    @IBOutlet weak var sendRequestButton: UIButton!
    
    // MARK: - Send Http Body to endpoint
    @IBAction func requestOrder(_ sender: UIButton) {
        
        let json = self.toDict(text: self.textView.text)
        let lineItems = json!["lineItems"] as! [AnyObject]
       
        let body: [String: Any] = [
            "locationId": json!["locationId"] as Any,
            "lineItems": lineItems
            ]
    
        let data = try? JSONSerialization.data(withJSONObject: body)
        
        let url: URL = URL(string: "http://localhost:3000/routes/createOrder")!
        let session = URLSession(configuration: .default)
        var dataTask = URLSessionDataTask()
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        req.httpBody = data
        
        dataTask = session.dataTask(with: req, completionHandler: { (data, res, err) in
            DispatchQueue.main.async {
            do {
                let jsonRes = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                self.responseView.text = jsonRes?.description
            } catch {
                self.responseView.text = "Error"
            }
            }
            
        })
        dataTask.resume()
        
    }
    
    // MARK: - Converts json string into a dictionary
    func toDict(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                 self.responseView.text = "Error"
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}
