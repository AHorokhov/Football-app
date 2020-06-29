//
//  Footbolico_appTests.swift
//  Footbolico appTests
//
//  Created by Alexey Horokhov on 25.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import XCTest
@testable import Footbolico_app
import RxSwift

class Footbolico_appTests: XCTestCase {

    let disposeBag = DisposeBag()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testFetching() {
        Manager.shared.fetchData()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { leagues in
                // Cheking if leagues more then 0
                // if equal, then we have corrupted data
                XCTAssertNotEqual(leagues?.count, 0)
            })
            .disposed(by: disposeBag)
    }

}
