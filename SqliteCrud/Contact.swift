//
//  Contact.swift
//  SqliteCrud
//
//  Created by GraceToa on 23/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import Foundation

class Contact: CustomStringConvertible {
    
    
    var id: Int64
    var category: String?
    var name: String?
    var birthday: String?
    var about: String?
    var image: String?

    init(id: Int64, category: String?, name: String?, birthday: String?, about: String?, image: String?) {
        self.id = id
        self.category = category
        self.name = name
        self.birthday = birthday
        self.about = about
        self.image = image
    }
    
    var description: String {
        return "id = \(self.id),category = \(self.category ?? ""),name = \(self.name ?? ""),birthday = \(self.birthday ?? ""),about = \(self.about ?? "") "
    }

}
