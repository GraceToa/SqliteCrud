//
//  DetailContactViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 22/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class DetailContactViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var about: UILabel!
    
    var contact: Contact!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContact))
        navigationItem.rightBarButtonItem = edit

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let contactsQuery: AnySequence = ContactEntity.shared.someContactExists(ids: contact.id){
            for c in contactsQuery {
                let contact = ContactEntity.shared.getContactFromQuery(queryContact: c)
                changeTitleNavBar(category: contact.category!)
                
                setColorWordInLabel(main_string: "Name: \(contact.name ?? "")", string_to_color: "Name:",label: name)
                setColorWordInLabel(main_string: "Category: \(contact.category ?? "")", string_to_color: "Category:", label: category)
                setColorWordInLabel(main_string: "Date Birthday: \(contact.birthday ?? "")", string_to_color: "Date Birthday:", label: birthday)
                about.text = "\(contact.name ?? ""), \(contact.about ?? "")"
            }
        }
    }

    // MARK: - Private Methods
    
   @objc func editContact()  {
        performSegue(withIdentifier: "ShowEditContact", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditContact" {
                let destin = segue.destination as! AddContactViewController
                destin.contact = contact
            
        }
    }
    
    func addIconLabel(icon: UIImage, label: UILabel, word: String)  {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = icon
        let imageOffsetY:CGFloat = -2.0;
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let  textAfterIcon = NSMutableAttributedString(string: word)
        completeText.append(textAfterIcon)
        label.textAlignment = .center;
        label.attributedText = completeText;
    }
  
    
    func changeTitleNavBar(category: String)  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = HelperManager.shared.setImageForCategory(category: category)
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func setColorWordInLabel(main_string: String, string_to_color: String, label: UILabel) {
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 232 / 255.0, green: 117 / 255.0, blue: 80 / 255.0, alpha: 1.0), range: range)
        
        label.attributedText = attribute
    }
}
