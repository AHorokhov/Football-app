//
//  League.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 25.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonConvertible {
    
    init(json: JSON)
    
}

class League: NSObject {
    
    let identifier: Int
    let name: String
    let logoUrl: String
    let events: [Event]
    
    // MARK: lifecycle
    
    required init(json: JSON) {
        
        identifier = json["id"].intValue
        name = json["name"].stringValue
        logoUrl = json["logoUrl"].stringValue
        events = json["events"].arrayValue.compactMap { Event(json: $0) }
    }
}

