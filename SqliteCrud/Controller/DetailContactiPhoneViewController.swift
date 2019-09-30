//
//  DetailContactiPhoneViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 30/09/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class DetailContactiPhoneViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    var contactiPhone: ContactiPhone!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contactiPhone {
            name.text = "Contact: \(contact.name)"
            lastname.text = contact.lastname
            phone.text = "Phone: \(contact.phone)"
            
        }
    }
   
    // MARK: - Actions
    
    @IBAction func call(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowCall", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCall" {
            let destin = segue.destination as! CallViewController
            destin.phoneContact = phone.text!
            }
        }
    
    
    @IBAction func sms(_ sender: UIButton) {
        
    }
    
    @IBAction func email(_ sender: UIButton) {
        
    }
    
 

}
