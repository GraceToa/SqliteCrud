//
//  AddContactViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 22/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tableCateg: UITableView!
    @IBOutlet weak var aboutPerson: UITextView!
    
    var categories = ["Family", "Friends","Best Friends","Partner","Coworkes","Classmates","Teammates"]
    var category: String = ""
    var image: UIImage?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableCateg.isHidden = true
    }
    
    // MARK: - Actions methods

    @IBAction func done(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        let dateBirthday = formatter.string(from: datePicker.date)
        
        let imageData = image?.jpegData(compressionQuality: 0.25)
        let strBase64:String = (imageData?.base64EncodedString(options: .lineLength64Characters))!
        let nsd: NSData = NSData(base64Encoded: imageData!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

//        let dataI = Data(base64Encoded: imageData!, options: .ignoreUnknownCharacters)


//        if name.text == "" || dateBirthday == "" || image == nil || category == "" {
//
//        }
//        DatabaseManagement.shared.insert(category: category, name: name.text!, birthday: dateBirthday, about: aboutPerson.text, image: nsd.bytes )
    }
    
    @IBAction func SHOW(_ sender: Any) {
        for row in (try! DatabaseManagement.shared.conn?.prepare("SELECT id, category, name, birthday, about FROM Contact"))! {
            print("id: \(row[0]!), category: \(row[1]!), name: \(row[2]!), birthday: \(row[3]!), about: \(row[4]!), image: \(row[5]!)")
        }
        
    }
    
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


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


extension AddContactViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageTake = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = imageTake!
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Add Picture
    
    @IBAction func takePhoto(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        else {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}


