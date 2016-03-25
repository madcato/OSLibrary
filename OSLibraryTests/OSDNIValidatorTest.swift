//
//  OSDNIValidatorTest.swift
//  OSLibrary
//
//  Created by Daniel Vela on 25/03/16.
//  Copyright © 2016 veladan. All rights reserved.
//

import XCTest

class OSDNIValidatorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBadDNI1() {
        XCTAssertFalse(OSDNIValidator.validateSpanishNationalIdentifier("12345678A"))
    }
    
    func testGoodDNI1() {
        XCTAssertTrue(OSDNIValidator.validateSpanishNationalIdentifier("04252816R"))
    }
    
    func testBadDNI2() {
        XCTAssertFalse(OSDNIValidator.validateSpanishNationalIdentifier("04252816F"))
    }
    
    func testGoodDNI2() {
        XCTAssertTrue(OSDNIValidator.validateSpanishNationalIdentifier("X3157772X"))
    }
    
    func testBadDNI3() {
        XCTAssertFalse(OSDNIValidator.validateSpanishNationalIdentifier("X3157772Y"))
    }
    
//    func testGoodCIF1() {
//        XCTAssertTrue(OSDNIValidator.validateSpanishNationalIdentifier("D16733008"))
//    }
//
//    func testBadCIF1() {
//        XCTAssertFalse(OSDNIValidator.validateSpanishNationalIdentifier("D16733009"))
//    }
//    
//    func testGoodCIF2() {
//        XCTAssertTrue(OSDNIValidator.validateSpanishNationalIdentifier("P7170573E"))
//    }
//    
//    func testBadCIF2() {
//        XCTAssertFalse(OSDNIValidator.validateSpanishNationalIdentifier("P7170573A"))
//    }
}
