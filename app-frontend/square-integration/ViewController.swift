//
//  ViewController.swift
//  square-integration
//
//  Created by steven freed on 6/19/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Apis
    let sections = ["Orders Api", "Transactions Api", "Customers Api"]
    // Api Functions
    let dataSource = [["Create Order"], ["Charge"], ["Create Customer", "Retrieve Customer", "Create Customer Card", "Delete Customer Card", "Retrieve Customer Cards"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let nameLbl = cell.textLabel
        nameLbl?.text = dataSource[indexPath.section][indexPath.row]
        
        return cell
    }
    
    // MARK: - Segues to view for cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.section)
        {
        case 0:
            // Orders Api -> Create Order
            self.performSegue(withIdentifier: "showCreateOrder", sender: dataSource[indexPath.section][indexPath.row])
            break
        case 1:
            // Transactions Api -> Charge
            self.performSegue(withIdentifier: "showCharge", sender: dataSource[indexPath.section][indexPath.row])
            break
        case 2:
            // Customers Api -> ...
            switch(dataSource[indexPath.section][indexPath.row])
            {
            case "Create Customer":
               self.performSegue(withIdentifier: "showCreateCustomer", sender: dataSource[indexPath.section][indexPath.row])
                break
            case "Retrieve Customer":
               self.performSegue(withIdentifier: "showRetrieveCustomer", sender: dataSource[indexPath.section][indexPath.row])
                break
            case "Create Customer Card":
               self.performSegue(withIdentifier: "showCreateCustomerCard", sender: dataSource[indexPath.section][indexPath.row])
                break
            case "Delete Customer Card":
               self.performSegue(withIdentifier: "showDeleteCustomerCard", sender: dataSource[indexPath.section][indexPath.row])
                break
            case "Retrieve Customer Cards":
                self.performSegue(withIdentifier: "showRetrieveCustomerCards", sender: dataSource[indexPath.section][indexPath.row])
            default:
                break
            }
        default:
            break
        }
    }
}

