//
//  Event.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 25.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Event: NSObject {
    
    let identifier: Int
    let startDateString: String
    let homeTeam: Team
    let awayTeam: Team
    let status: String
    let result: [String: Int]
    
    // Details
    var venue: [String: String]?
    var channel: String?
    
    // Calculated property
    
    var startDate: Date? {
        return convertStringIntoDate()
    }
    
    
    required init(json: JSON) {
        
        identifier = json["id"].intValue
        startDateString = json["startDate"].stringValue
        homeTeam = Team(json: json["homeTeam"])
        awayTeam = Team(json: json["awayTeam"])
        status = json["status"]["type"].stringValue
        result = json["result"]["runningScore"].dictionaryValue.mapValues { $0.intValue }
        
        //Details
        venue = json["venue"].dictionaryValue.mapValues { $0.stringValue }
        channel = json["tvChannel"].stringValue
    }
    
}


extension Event {
    
    func convertStringIntoDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: startDateString)
    }
    
}
