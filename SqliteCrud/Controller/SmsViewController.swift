//
//  SmsViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 05/10/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import MessageUI

class SmsViewController: UIViewController,MFMessageComposeViewControllerDelegate {
 
    
    @IBOutlet weak var nameContact: UILabel!
    @IBOutlet weak var sms: UITextView!
    
    
    
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

    @IBAction func sendSms(_ sender: UIButton) {
        if phone == "" || sms.text == "" {
            let alert = UIAlertController(title: "Error fields", message: "The fields are empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if MFMessageComposeViewController.canSendText() {
            let message = MFMessageComposeViewController()
            message.body = sms.text
            message.recipients = [phone]
            message.messageComposeDelegate = self
            present(message,animated: true,completion: nil)
        }else {
            let alert = UIAlertController(title: "Error sms", message: "The fields are empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
}
