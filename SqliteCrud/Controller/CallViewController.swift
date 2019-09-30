//
//  CallViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 30/09/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    @IBOutlet weak var phone: UILabel!
    
    var phoneContact:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let phoneC = phoneContact {
            phone.text = phoneC
        }
    }
    

    // MARK: - Navigation

    @IBAction func call(_ sender: UIButton) {
        let url = URL(string: "TEL://" + phone.text!)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    

}
