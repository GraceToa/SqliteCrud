//
//  AddContactViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 22/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import EventKit


class AddContactViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tableCateg: UITableView!
    @IBOutlet weak var aboutPerson: UITextView!
   
    
    var categories = HelperManager.shared.categories
    var category: String = ""
    var contact: Contact!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add or Edit Contact"
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneBtn
        tableCateg.isHidden = true
        
        if let contact = contact {
            name.text = contact.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "dd-MMMM-yyyy"
            let date = dateFormatter.date(from: contact.birthday!)
            datePicker.date = date!
            category = contact.category!
            btnDrop.setTitle(category, for: .normal)
            aboutPerson.text = contact.about
        }
        btnDrop.layer.cornerRadius = 4
        aboutPerson.layer.cornerRadius = 4
        

    }
    
    // MARK: - Actions methods

    @objc func done() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        let dateBirthday = formatter.string(from: datePicker.date)
        
        
        if name.text == "" || dateBirthday == ""  || category == "What is your personal relationship?" {
            let alert = UIAlertController(title: "Error fields", message: "The fields are empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if contact != nil {
            if ContactEntity.shared.update(ids: contact.id, category: category, name: name.text!, birthday: dateBirthday, about: aboutPerson.text) {
                showToast(message: "Update successful!")
                clearFields()
            }
        }else{
            ContactEntity.shared.insert(category: category, name: name.text!, birthday: dateBirthday, about: aboutPerson.text )
            showToast(message: "Create New Contact!")
            clearFields()
        }
    }

    
    @IBAction func datePickerBtn(_ sender: UIDatePicker) {
    }
    
    @IBAction func onClickDropBtn(_ sender: Any) {
        if tableCateg.isHidden {
            animate(toogle: true)
        }else{
            animate(toogle: false)
        }
    }
    
    func animate(toogle: Bool)  {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.tableCateg.isHidden = false
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.tableCateg.isHidden = true
            }
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
        
    // MARK: - Helpers Methods
 
    func clearFields()  {
        name.text = ""
        btnDrop.setTitle("What is your personal relationship?", for: .normal)
        aboutPerson.text = ""
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

    // MARK: - TableView Methods

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableCateg.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = categories[indexPath.row]
        btnDrop.setTitle("\(categories[indexPath.row])", for: .normal)
        animate(toogle: false)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}



