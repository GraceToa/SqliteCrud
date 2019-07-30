//
//  Database.swift
//  SqliteCrud
//
//  Created by GraceToa on 21/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import Foundation
import SQLite

class Database {
    static let shared = Database()
    public let conn: Connection?
    public let dataBaseName = "sqlitecrud.sqlite3"
    
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
    
}
