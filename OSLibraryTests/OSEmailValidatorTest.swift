//
//  OSEmailValidatorTest.swift
//  OSLibrary
//
//  Created by Daniel Vela on 06/03/16.
//  Copyright © 2016 veladan. All rights reserved.
//

import XCTest

class OSEmailValidatorTest: XCTestCase {
    
    var validator: OSEmailValidator!
    
    override func setUp() {
        super.setUp()
        
        validator = OSEmailValidator()
    }
    
    override func tearDown() {
        validator = nil
        
        super.tearDown()
    }
    
    func testGoodEmail1() {
        XCTAssertTrue(validator.isValid("dani_vela@me..s.com"), "Mail validator fail verifing a good email 1")
    }

    func testGoodEmail2() {
        XCTAssertTrue(validator.isValid("veladan@gmail.com"), "Mail validator fail verifing a good email 2")
    }

    func testBadEmail1() {
        XCTAssertFalse(validator.isValid("dani_velame.com"), "Mail validator fail verifing a bad email 1")
    }

    func testBadEmail2() {
        XCTAssertFalse(validator.isValid("veladan@gmail"), "Mail validator fail verifing a bad email 2")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
