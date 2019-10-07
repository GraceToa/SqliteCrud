//
//  CallViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 30/09/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    @IBOutlet weak var nameContact: UILabel!
    
    var contactiPhone: ContactiPhone!
    var phone: String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contactiPhone {
            nameContact.text = contact.name
            phone = contact.phone
        }
    }
    

    // MARK: - Navigation

    @IBAction func call(_ sender: UIButton) {
        let url = URL(string: "TEL://" + phone)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    

}
