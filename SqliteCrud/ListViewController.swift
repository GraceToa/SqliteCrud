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
    
    var listContacts = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
//        getContacts()

    }

    // MARK: - Private methods
    
    func getContacts()  {
        
        for row in (try! DatabaseManagement.shared.conn?.prepare("SELECT id, category, name, birthday, about, image FROM Contact"))! {
            let id = row[0]! as! Int64
            let category = row[1]! as! String
            let name = row[2]! as! String
            let birthday = row[3]! as! String
            let about = row[4]! as! String
            let image = row[5]! as! String

            let c = Contact(id: id, category: category, name: name, birthday: birthday, about: about, image: image)
            listContacts.append(c)
            
        }
        
    }


}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableList.dequeueReusableCell(withIdentifier: "cellList", for: indexPath) as! ContactTableViewCell
        let c = listContacts[indexPath.row]
        cell.name.text = c.name
        cell.category.text = c.category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = listContacts[indexPath.row]
            let id = contact.id
            DatabaseManagement.shared.delete(ids: id)
        }
        DispatchQueue.main.async {
            self.tableList.reloadData()
        }
    }
}
