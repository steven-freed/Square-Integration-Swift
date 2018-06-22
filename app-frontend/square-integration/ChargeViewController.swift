//
//  ChargeViewController.swift
//  square-integration
//
//  Created by steven freed on 6/19/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit

class ChargeViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var responseView: UITextView!
    
   // MARK: - Send Http Body to endpoint
    @IBAction func requestCharge(_ sender: UIButton) {
  
    // get values from textview
    let json = self.toDict(text: self.textView.text)
    
    let body: [String: Any] = [
        "locationId": json!["locationId"],
        "amount": json!["amount"],
        "customerCardId": json!["customerCardId"],
        "customerId": json!["customerId"]
    ]
    
    let data = try? JSONSerialization.data(withJSONObject: body)
    
    let url: URL = URL(string: "http://localhost:3000/routes/charge")!
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
        
        // Do any additional setup after loading the view.
    }

}
