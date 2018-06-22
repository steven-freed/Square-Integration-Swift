//
//  RetrieveCustomerCardsViewController.swift
//  square-integration
//
//  Created by steven freed on 6/21/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit

class RetrieveCustomerCardsViewController: UIViewController, selectedMethodDelegate {

    @IBOutlet weak var selectedCardView: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var responseView: UITextView!
    
    // holds payment methods
    var paymentMethods: [PaymentMethod] = []
    
     // MARK: - Send Http Body to endpoint
    @IBAction func requestCustomerCards(_ sender: UIButton) {

    // get values from textview
    let json = self.toDict(text: self.textView.text)
    
    let body: [String: Any] = [
        "customerId": json!["customerId"]
    ]
    
    let data = try? JSONSerialization.data(withJSONObject: body)
    
        let url: URL = URL(string: "http://localhost:3000/routes/retrieveCustomerCards")!
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
                let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
                self.responseView.text = jsonArray?.description
                let array = jsonArray!
       
                for method in array {
                    let dict = method as! NSDictionary
                    let brand = dict["card_brand"]! as! String
                    let last4 = "**** **** **** \(dict["last_4"]! as! String)"
                    let id = dict["id"]! as! String
                    let method = PaymentMethod.init(brand: brand, last4: last4, id: id)
                    self.paymentMethods.append(method)
                }
        
            } catch {
                self.responseView.text = "Error"
            }
        }
        })
        dataTask.resume()
    
}
    
    // MARK: - Prepares for PaymentPopupUIViewController by setting the delegate and dataSource for the table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showPaymentPopupUI"
        {
            let nextController = segue.destination as! PaymentPopupUIViewController
            nextController.delegate = self
            nextController.dataSource.append(contentsOf: self.paymentMethods)
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
    
    // MARK: - Delegate method for PaymentPopupUIViewController for recieving the card_id
    func didSelectPayment(method: String) {
        self.selectedCardView.text = method
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
