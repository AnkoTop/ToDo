//
//  ItemCellTests.swift
//  ToDo
//
//  Created by Anko Top on 25/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import XCTest

@testable import ToDo

class ItemCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_HasNameLabel() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController
        
        _ = controller.view
        
        let tableView = controller.tableView
        tableView.dataSource = FakeDataSource()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        //, forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        
        XCTAssertNotNil(cell.titleLabel)
    }
}

//MARK - FAKING

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return 1
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            return UITableViewCell()
        }
    }
}