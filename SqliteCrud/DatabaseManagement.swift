//
//  Database.swift
//  SqliteCrud
//
//  Created by GraceToa on 21/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManagement {
    static let shared = DatabaseManagement()
    public let conn: Connection?
    public let dataBaseName = "sqlitecrud.sqlite3"
    
    private let table = Table("Contact")
    
    private let id = Expression<Int64>("id")
    private let category = Expression<String>("category")
    private let nameContact = Expression<String>("name")
    private let dateBirthday = Expression<String>("birthday")
    private let aboutContact = Expression<String>("about")
    private let image = Expression<Blob>("image")
    
    private init() {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
           conn =  try Connection("\(dbPath)/(dataBaseName)")
        } catch  {
            conn = nil
            let error = error as NSError
            print("Error connection",error)
        }
    }
    
    func createTableContatc()  {
        
        do {
            if let conn = DatabaseManagement.shared.conn {
                try conn.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (t) in
                    t.column(id, primaryKey: true)
                    t.column(category)
                    t.column(nameContact)
                    t.column(dateBirthday)
                    t.column(aboutContact)
                    t.column(image)
                }))
                print("Create table successfully")
            }else{
                print("Table not create")
            }
        } catch let error as NSError {
            print("Unable to create table", error)
        }
    }
    
    //Insert
    func insert(category: String, name: String, birthday: String, about: String, image: Blob) {
        
        do {
            let insert = table.insert(self.category <- category, self.nameContact <- name, self.dateBirthday <- birthday, self.aboutContact <- about, self.image <- image)
            try DatabaseManagement.shared.conn?.run(insert)
            print("Insert to tableContact successfully")
        } catch let error as NSError {
            print("Cannot insert to BD ", error)
        }
    }
    
    func update(ids: Int64, category: String, name: String, birthday: String, about: String)  {
        let identifier = table.filter(id == ids)
        try! DatabaseManagement.shared.conn?.run(identifier.update(self.category <- category, self.nameContact <- name, self.dateBirthday <- birthday, self.aboutContact <- about))
        print("Edit OK")
    }
    
    func delete(ids: Int64)  {
        let identifier = table.filter(id == ids)
        try! DatabaseManagement.shared.conn?.run(identifier.delete())
        print("Delete OK")
    }
    
}
