//
//  HelperManager.swift
//  SqliteCrud
//
//  Created by GraceToa on 06/09/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import Foundation
import MapKit

class HelperManager {
    
    static let shared = HelperManager()
    
    var categories = ["Family", "Friends","Best Friends","Partner","Coworkes"]
    
    
    func setImageForCategory(category: String) -> UIImage {
        var image: UIImage!
        
        switch category {
        case "Family":
            image = UIImage(named: "family.png")
        case "Friends":
            image = UIImage(named: "friends.png")
        case "Best Friends":
                image = UIImage(named: "bestFriends.png")
        case "Partner":
            image = UIImage(named: "partner.png")
        case "Coworkes":
            image = UIImage(named: "workers.png")
        case "Classmates":
            image = UIImage(named: "classmates.png")
        default:
            print("Some other category")
            image = UIImage(named: "placeholder.png")
        }
        return image
    }

}
