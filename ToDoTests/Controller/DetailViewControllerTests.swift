//
//  DetailViewControllerTests.swift
//  ToDo
//
//  Created by Anko Top on 26/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import XCTest

@testable import ToDo

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasTitleLabel() {
        
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func test_HasDateLAbel() {
        
        XCTAssertNotNil(sut.dateLabel)
    }
    
    func test_HasLocationLabel() {
   
        XCTAssertNotNil(sut.locationLabel)
    }
    
    func test_HasItemDescriptionLabel() {
        
        XCTAssertNotNil(sut.itemDescriptionLabel)
    }
    

}
