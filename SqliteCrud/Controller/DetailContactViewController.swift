//
//  DetailContactViewController.swift
//  SqliteCrud
//
//  Created by GraceToa on 22/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class DetailContactViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var eventStart: UITextField!
    @IBOutlet weak var eventEnd: UITextField!
    
    let picker = UIDatePicker()
    
    var contact: Contact!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContact))
        navigationItem.rightBarButtonItem = edit
        
        //Events
        createPickerStart()
        createPickerEnd()
        
        UNUserNotificationCenter.current().delegate = self

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
    
    // MARK: - EKEvent Methods
    
    @IBAction func createEvent(_ sender: UIButton) {
        
        if eventStart.text == "date start"  || eventEnd.text == "date end"{
            let alert = UIAlertController(title: "Error", message: "The event needs dates", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (working, error) in
                if working == true && error == nil {
                    print("event create OK")
                    let event = EKEvent(eventStore: eventStore)
                    event.title = "Birthday  \(self.name.text ?? "Not name") Reminder"
                    event.startDate = self.convertDateFormater(time: self.eventStart.text!)
                    event.endDate = self.convertDateFormater(time: self.eventEnd.text!)
                    event.notes = " \(self.name.text ?? "Not name") \(self.about.text ?? "Not about")"
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    do{
                        try eventStore.save(event, span: .thisEvent)
                        let alert = UIAlertController(title: "OK", message: "The event to create successful", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.clearFieldsEvent()
                    }catch let error as NSError {
                        print("Error to create event",error)
                    }
                    
                }
            }
        }
    }
    
    func createPickerStart()  {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(sendDateStart))
        toolBar.setItems([done], animated: true)
        eventStart.inputAccessoryView = toolBar
        eventStart.inputView = picker
    }
    @objc func sendDateStart() {
        eventStart.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    func createPickerEnd()  {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(sendDateEnd))
        toolBar.setItems([done], animated: true)
        eventEnd.inputAccessoryView = toolBar
        eventEnd.inputView = picker
    }
    @objc func sendDateEnd() {
        eventEnd.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    // MARK: - Helpers Methods
    
    //https://nsdateformatter.com/
    func convertDateFormater(time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: time)
        return date
    }
    
    func clearFieldsEvent()  {
        eventStart.text = ""
        eventEnd.text = ""
    }
}

    // MARK: - Notification Methods

extension DetailContactViewController: UNUserNotificationCenterDelegate {
    
    //notification show inside app and device
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    @IBAction func createNotification(_ sender: Any) {
        print("ENTRA")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Happy birthday \(self.name.text ?? "Not name")"
        content.subtitle = "This day is your Birthday"
        content.body = "This is reminder birthday, \(self.about.text ?? "Not about")"
        content.sound = UNNotificationSound.default
        
        if let path = Bundle.main.path(forResource: "birthday", ofType: "png"){
            let url = URL(fileURLWithPath: path)
            do{
                let image = try UNNotificationAttachment(identifier: "birthday", url: url, options: nil)
                content.attachments = [image]
                
            }catch{
                print("Error load image")
            }
        }
        
        
        
        
        let request = UNNotificationRequest(identifier: "notif1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error Notification",error)
            }
        }
    }
    
    
}
