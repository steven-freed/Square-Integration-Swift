//
//  CreateCustomerCardViewController.swift
//  square-integration
//
//  Created by steven freed on 6/19/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit

class CreateCustomerCardViewController: UIViewController, nonceDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var responseView: UITextView!
    @IBOutlet weak var nonceButton: UIButton!
    
    // MARK: - Send Http Body to endpoint
    @IBAction func requestAddCard(_ sender: UIButton) {
    
    // get values from textview
    let json = self.toDict(text: self.textView.text)
    
    let body: [String: Any] = [
        "customerId": json!["customerId"],
        "cardNonce": self.nonceButton.currentTitle!
    ]
    
    let data = try? JSONSerialization.data(withJSONObject: body)
    
    let url: URL = URL(string: "http://localhost:3000/routes/createCustomerCard")!
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
    
    // MARK: - Segues to show the SqPaymentForm view controller
    @IBAction func getNonce(_ sender: UIButton) {
         self.performSegue(withIdentifier: "showForm", sender: self)
    }
    
    // MARK: - Delegate method to recieve the payment method nonce from the SqPaymentForm view controller
    func getNonce(nonce: String?) {
        self.nonceButton.setTitle(nonce!, for: .normal)
    }
    
    // MARK: - Prepares for SqPaymentFormViewController by setting the delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showForm"
        {
            let nextController = segue.destination as! SqPaymentFormViewController
            nextController.delegate = self
        }
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
