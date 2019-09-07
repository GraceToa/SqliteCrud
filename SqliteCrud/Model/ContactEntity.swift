//
//  ContactEntity.swift
//  SqliteCrud
//
//  Created by GraceToa on 02/09/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import Foundation
import SQLite


class ContactEntity {
    
    static let shared = ContactEntity()
    private let table = Table("Contact")
    
    private let id = Expression<Int64>("id")
    private let category = Expression<String>("category")
    private let nameContact = Expression<String>("name")
    private let dateBirthday = Expression<String>("birthday")
    private let aboutContact = Expression<String>("about")
    
    private init(){
        do {
            if let conn = DatabaseManagement.shared.conn {
                try conn.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                    t.column(id, primaryKey: true)
                    t.column(category)
                    t.column(nameContact)
                    t.column(dateBirthday)
                    t.column(aboutContact)
                }))
                print("Create table successfully")
            }else{
                print("Table not create")
            }
        } catch let error as NSError {
            print("Unable to create table", error)
        }
    }
    
    
    func insert(category: String, name: String, birthday: String, about: String) {
        do {
            let insert = table.insert(self.category <- category, self.nameContact <- name, self.dateBirthday <- birthday, self.aboutContact <- about)
            try DatabaseManagement.shared.conn?.run(insert)
            print("Insert Contact successfully")
        } catch let error as NSError {
            print("Cannot insert Contact to BD ", error)
        }
    }
    
    func update(ids: Int64, category: String, name: String, birthday: String, about: String)-> Bool {
        
        do {
            let identifier = table.filter(id == ids)
            var setters: [SQLite.Setter] = [SQLite.Setter]()
            
            setters.append(self.category <- category)
            setters.append(self.nameContact <- name)
            setters.append(self.dateBirthday <- birthday)
            setters.append(self.aboutContact <- about)
            
            if setters.count == 0 {
                print("Nothing to update")
                return false
            }
            
            let update = identifier.update(setters)
            if try DatabaseManagement.shared.conn!.run(update) <= 0 {
                return false
            }
            return true
        } catch  {
            let nserror = error as NSError
            print("Cannot update  Table Contact", nserror)
            return false
        }
    }
    
    func delete(ids: Int64)  {
        let identifier = table.filter(id == ids)
        try! DatabaseManagement.shared.conn?.run(identifier.delete())
        print("Delete OK")
    }
    
    func queryAllContacts() -> AnySequence<Row>? {
        do {
           return try DatabaseManagement.shared.conn?.prepare(table)
        } catch  {
            let nserror = error as NSError
            print("Cannot query all Table Contact", nserror)
            return nil
        }
    }

    func getContactFromQuery(queryContact: Row) -> Contact {
        let contact = Contact(id: queryContact[id], category: queryContact[category], name: queryContact[nameContact], birthday: queryContact[dateBirthday], about: queryContact[aboutContact])

        return contact
    }
    
    func someContactExists(ids: Int64) -> AnySequence<Row>? {
        
        do {
            let identifier = table.filter(id == ids)
           return try  DatabaseManagement.shared.conn?.prepare(identifier)
        } catch  {
            let nserror = error as NSError
            print("Cannot list / query objects in tableContact. Error is:\(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func toString(contact: Row)  {
        print("Contact: ID: \(contact[id])Name: \(contact[nameContact]) Category: \(contact[category]) Date Birthday: \(contact[dateBirthday]) About: \(contact[aboutContact])")
    }
    
}
