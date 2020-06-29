//
//  Team.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 26.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import SwiftyJSON

struct Team {
    
    let id: String
    let name: String
    let logoUrl: String
    let isWinner: Bool
    
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        logoUrl = json["logoUrl"].stringValue
        isWinner = json["isWinner"].boolValue
    }
}
