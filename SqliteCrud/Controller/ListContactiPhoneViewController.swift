//
//  ListContactiPhoneViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 30/09/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Contacts

class ListContactiPhoneViewController: UIViewController {

    @IBOutlet weak var tableContactsiPhone: UITableView!

    var contacts = [ContactiPhone]()
    var contactsStore = CNContactStore()
    var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        navigationItem.rightBarButtonItem = editBtn
        
        
        contactsStore.requestAccess(for: .contacts) { (accept, error) in
            if accept {
                print("access sucessfull")
            }else {
                print("unsucessfull")
            }
            
            if let error = error {
                print("can't load contacts", error)
            }
        }
        
        fetchContacts()
    }
    

    // MARK: - Method Private
    
    func fetchContacts() {
        let key =  [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        request.sortOrder = CNContactSortOrder.familyName
        try! contactsStore.enumerateContacts(with: request, usingBlock: { (contact, point) in
            let name = contact.givenName
            let lastname = contact.familyName
            let phone = contact.phoneNumbers.first?.value.stringValue
            let contactAdd = ContactiPhone(name: name, lastname: lastname, phone: phone!)
            self.contacts.append(contactAdd)
            
        })
        DispatchQueue.main.async {
            self.tableContactsiPhone.reloadData()
        }
    }
    
    @objc func edit()  {
        tableContactsiPhone.isEditing = !tableContactsiPhone.isEditing
        if tableContactsiPhone.isEditing {
            editBtn = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem = editBtn

        }else{
            editBtn.title = "Edit"
        }
    }

}
extension ListContactiPhoneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableContactsiPhone.dequeueReusableCell(withIdentifier: "cellContact", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.name) \(contact.lastname)"
        cell.detailTextLabel?.text = contact.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailContactiPhone", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailContactiPhone" {
            if let id = tableContactsiPhone.indexPathForSelectedRow {
                let rowContact = contacts[id.row]
                let destin = segue.destination as! DetailContactiPhoneViewController
                destin.contactiPhone = rowContact
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.tableContactsiPhone.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = contacts[sourceIndexPath.row]
        contacts.remove(at: sourceIndexPath.row)
        contacts.insert(item, at: sourceIndexPath.row)
    }
}

struct ContactiPhone {
    let name: String
    let lastname: String
    let phone: String
    
}
