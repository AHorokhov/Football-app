//
//  Manager.swift
//  Footbolico app
//
//  Created by Alexey Horokhov on 25.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import SwiftyJSON

class Manager {
    
    static let shared = Manager()
    static let mainUrlString = "https://sports-app-code-test.herokuapp.com/api/events?date=today"
    static let detailsURLString = "https://sports-app-code-test.herokuapp.com/api/events/"
    
    func fetchData() -> Observable<[League]?> {
        guard let url = URL(string: Manager.mainUrlString) else { return .just([])}
        return SessionManager.default.rx.request(.get, url)
            .data()
            .map { data -> [League]? in
                let json = try? JSON(data: data)
                guard let unwrappedJson = json else { return nil }
                let leagueList = unwrappedJson.arrayValue.compactMap { League(json: $0) }
                return leagueList
        }
    }
    
    func fetchDetails(for eventId: Int) -> Observable<Event?> {
        guard let url = URL(string: Manager.detailsURLString + "\(eventId)") else { return .just(nil)}
        return SessionManager.default.rx.request(.get, url)
            .data()
            .map { data -> Event? in
                let json = try? JSON(data: data)
                guard let unwrappedJson = json else { return nil }
                let event = Event(json: unwrappedJson["event"])
                return event
        }
    }
}
