//
//  ListViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 22/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableList: UITableView!
    
    var contacts = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contacts =  getContacts()
        DispatchQueue.main.async {
            self.tableList.reloadData()
        }
    }

    // MARK: - Private methods
    
    func getContacts()-> [Contact]  {
        var contacts2 = [Contact]()
        if let contactsQuery: AnySequence = ContactEntity.shared.queryAllContacts(){
            for c in contactsQuery {
                let contact = ContactEntity.shared.getContactFromQuery(queryContact: c)
                contacts2.append(contact)
            }
        }
      return contacts2
    }
    
    @IBAction func addContact(_ sender: Any) {
        performSegue(withIdentifier: "ShowAddContact", sender: self)
    }
    
}

    // MARK: - TableView Methods

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableList.dequeueReusableCell(withIdentifier: "cellList", for: indexPath) as! ContactTableViewCell
        let c = contacts[indexPath.row]
        cell.name.text = c.name
        cell.category.text = c.category
        let image = HelperManager.shared.setImageForCategory(category: c.category!)
        cell.imageL.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let id = tableList.indexPathForSelectedRow {
                let rowContact = contacts[id.row]
                let destin = segue.destination as! DetailContactViewController
                destin.contact = rowContact
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = contacts[indexPath.row]
            let id = contact.id
            ContactEntity.shared.delete(ids: id)
            contacts = getContacts()
            tableList.reloadData()
        }
       
    }
}
