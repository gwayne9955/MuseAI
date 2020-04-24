//
//  MuseAITests.swift
//  MuseAITests
//
//  Created by Garrett Wayne on 1/31/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import XCTest
@testable import MuseAI

class MuseAITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var response = String("{\n    \"ticksPerQuarter\": 220,\n    \"tempos\": [{\n        \"qpm\": 60.0\n    }],\n    \"notes\": [{\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"endTime\": 0.5\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 0.5,\n            \"endTime\": 1.0\n        },\n        {\n            \"pitch\": 67,\n            \"velocity\": 100,\n            \"startTime\": 1.0,\n            \"endTime\": 1.5\n        },\n        {\n            \"pitch\": 67,\n            \"velocity\": 100,\n            \"startTime\": 1.5,\n            \"endTime\": 2.0\n        },\n        {\n            \"pitch\": 69,\n            \"velocity\": 100,\n            \"startTime\": 2.0,\n            \"endTime\": 2.5\n        },\n        {\n            \"pitch\": 69,\n            \"velocity\": 100,\n            \"startTime\": 2.5,\n            \"endTime\": 3.0\n        },\n        {\n            \"pitch\": 67,\n            \"velocity\": 100,\n            \"startTime\": 3.0,\n            \"endTime\": 4.0\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 4.0,\n            \"endTime\": 4.5\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 4.5,\n            \"endTime\": 5.0\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 5.0,\n            \"endTime\": 5.5\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 5.5,\n            \"endTime\": 6.0\n        },\n        {\n            \"pitch\": 62,\n            \"velocity\": 100,\n            \"startTime\": 6.0,\n            \"endTime\": 6.5\n        },\n        {\n            \"pitch\": 62,\n            \"velocity\": 100,\n            \"startTime\": 6.5,\n            \"endTime\": 7.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 7.0,\n            \"endTime\": 8.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 8.5,\n            \"endTime\": 9.0\n        },\n        {\n            \"pitch\": 67,\n            \"velocity\": 100,\n            \"startTime\": 9.0,\n            \"endTime\": 9.5\n        },\n        {\n            \"pitch\": 67,\n            \"velocity\": 100,\n            \"startTime\": 9.5,\n            \"endTime\": 10.0\n        },\n        {\n            \"pitch\": 69,\n            \"velocity\": 100,\n            \"startTime\": 10.0,\n            \"endTime\": 10.5\n        },\n        {\n            \"pitch\": 69,\n            \"velocity\": 100,\n            \"startTime\": 10.5,\n            \"endTime\": 11.0\n        },\n        {\n            \"pitch\": 67,\n            \"velocity\": 100,\n            \"startTime\": 11.0,\n            \"endTime\": 12.0\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 12.0,\n            \"endTime\": 12.5\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 12.5,\n            \"endTime\": 13.0\n        },\n        {\n            \"pitch\": 72,\n            \"velocity\": 100,\n            \"startTime\": 13.0,\n            \"endTime\": 13.5\n        },\n        {\n            \"pitch\": 72,\n            \"velocity\": 100,\n            \"startTime\": 13.5,\n            \"endTime\": 14.0\n        },\n        {\n            \"pitch\": 59,\n            \"velocity\": 100,\n            \"startTime\": 14.0,\n            \"endTime\": 14.5\n        },\n        {\n            \"pitch\": 59,\n            \"velocity\": 100,\n            \"startTime\": 14.5,\n            \"endTime\": 15.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 15.0,\n            \"endTime\": 16.0\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 16.0,\n            \"endTime\": 17.0\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 17.0,\n            \"endTime\": 17.5\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 17.5,\n            \"endTime\": 18.0\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 18.0,\n            \"endTime\": 18.5\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 18.5,\n            \"endTime\": 19.0\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 19.0,\n            \"endTime\": 19.5\n        },\n        {\n            \"pitch\": 62,\n            \"velocity\": 100,\n            \"startTime\": 19.5,\n            \"endTime\": 20.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 20.0,\n            \"endTime\": 21.0\n        },\n        {\n            \"pitch\": 72,\n            \"velocity\": 100,\n            \"startTime\": 21.0,\n            \"endTime\": 21.5\n        },\n        {\n            \"pitch\": 72,\n            \"velocity\": 100,\n            \"startTime\": 21.5,\n            \"endTime\": 22.0\n        },\n        {\n            \"pitch\": 59,\n            \"velocity\": 100,\n            \"startTime\": 22.0,\n            \"endTime\": 22.5\n        },\n        {\n            \"pitch\": 59,\n            \"velocity\": 100,\n            \"startTime\": 22.5,\n            \"endTime\": 23.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 23.0,\n            \"endTime\": 24.0\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 24.0,\n            \"endTime\": 25.0\n        },\n        {\n            \"pitch\": 65,\n            \"velocity\": 100,\n            \"startTime\": 25.0,\n            \"endTime\": 26.0\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 26.0,\n            \"endTime\": 26.5\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 26.5,\n            \"endTime\": 27.0\n        },\n        {\n            \"pitch\": 64,\n            \"velocity\": 100,\n            \"startTime\": 27.0,\n            \"endTime\": 27.5\n        },\n        {\n            \"pitch\": 62,\n            \"velocity\": 100,\n            \"startTime\": 27.5,\n            \"endTime\": 28.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 28.0,\n            \"endTime\": 30.0\n        },\n        {\n            \"pitch\": 60,\n            \"velocity\": 100,\n            \"startTime\": 30.0,\n            \"endTime\": 32.0\n        }\n    ],\n    \"totalTime\": 32.0\n}")
        do {
            let a = try JSONDecoder().decode(MelodyResponse.self, from: response.data(using:.utf8)!)
            print(a)
        } catch {
            print("TEST ERROR")
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
