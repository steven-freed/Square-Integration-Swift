//
//  PaymentPopupUIViewController.swift
//  square-integration
//
//  Created by steven freed on 6/21/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit

protocol selectedMethodDelegate: class {
     func didSelectPayment(method: String)
}

class PaymentPopupUIViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    weak var delegate: selectedMethodDelegate?
    // Table view data displays payment methods
    var dataSource = [PaymentMethod]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // gesture recognizer to dismiss PaymentPopupUIView
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(closePopup(_sender:)))
        tapGesture.delegate = self
        self.tapGestureView.addGestureRecognizer(tapGesture)
        self.popupView.layer.cornerRadius = self.popupView.frame.height/15
        
    }
    
    // MARK: - Dismisses the PaymentPopupUIViewController when user taps
    //      outside the view containing the tableview of payment methods
    @objc func closePopup(_sender: UITapGestureRecognizer)
    {
       self.dismiss(animated: true, completion: nil)
    }

}

extension PaymentPopupUIViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.layer.cornerRadius = cell.frame.height/8
        cell.textLabel?.text = dataSource[indexPath.row]._last4
        cell.detailTextLabel?.text = dataSource[indexPath.row]._brand
        cell.imageView?.image = #imageLiteral(resourceName: "card")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectPayment(method: dataSource[indexPath.row]._id!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
