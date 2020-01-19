//
//  API_UserTests.swift
//  BestPracticeTests
//
//  Created by Bach Le on 1/19/20.
//  Copyright © 2020 Bach Le. All rights reserved.
//

import XCTest
@testable import BestPractice

class API_UserTests: XCTestCase {

    func testCanDecodeMissingName() {
        let data = """
        {
            "id": "user01",
            "email": "user01@mail.com"
        }
        """.data(using: .utf8)!
        
        let apiUser = try? JSONDecoder().decode(API_User.self, from: data)
        
        XCTAssertNotNil(apiUser)

        XCTAssertFalse(apiUser!.isResponseFullyParsable)
        
        let user = apiUser?.domainUser
        XCTAssertNotNil(user)
        XCTAssertEqual(user!, User(id: "user01", name: "bachld", email: "user01@mail.com"))
        XCTAssertTrue(
            apiUser!.codingKeysThatFails.contains(where: { $0.stringValue == API_User.CodingKeys._name.stringValue })
        )
    }
    
    func testCanDecodeMissingEmail() {
        let data = """
        {
            "id": "user01",
            "name": "Bach Le"
        }
        """.data(using: .utf8)!
        
        let apiUser = try? JSONDecoder().decode(API_User.self, from: data)
        
        XCTAssertNotNil(apiUser)
        XCTAssertFalse(apiUser!.isResponseFullyParsable)
        
        let user = apiUser?.domainUser
        XCTAssertNotNil(user)
        XCTAssertEqual(user!, User(id: "user01", name: "Bach Le", email: "bachld@email.com"))
        
        XCTAssertTrue(
            apiUser!.codingKeysThatFails.contains(where: {
                return $0.stringValue == API_User.CodingKeys._email.stringValue
            })
        )
    }
    
    func testCannotDecodeMissingId() {
        
    }
    

}
