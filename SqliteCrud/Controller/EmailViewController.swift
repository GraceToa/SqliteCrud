//
//  EmailViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 05/10/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var nameContact: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var message: UITextView!
    
    
    
    var contactiPhone: ContactiPhone!
    var phohe: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contactiPhone {
            nameContact.text = contact.name
            phohe = contact.phone
        }
    }
    
    
    // MARK: - Actions

    @IBAction func sendEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
            mail.setToRecipients([email.text!])
            mail.setSubject(subject.text!)
            mail.setMessageBody(message.text, isHTML: false)
            self.present(mail,animated: true,completion: nil)
        }else {
            print("Error send Email")
        }
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
  
}
