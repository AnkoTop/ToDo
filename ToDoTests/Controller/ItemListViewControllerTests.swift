//
//  ItemListViewControllerTests.swift
//  ToDo
//
//  Created by Anko Top on 24/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import XCTest

@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
    
    var sut: ItemListViewController!
    var inputViewController: InputViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController
        
        _ = sut.view

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    
    }
    
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        
        XCTAssertNotNil(sut.tableView)
    
    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource() {
        
        
        XCTAssertNotNil(sut.tableView!.dataSource)
        XCTAssertTrue(sut.tableView!.dataSource is ItemListDataProvider)
    
    }
    
    func testViewDidLoad_ShouldSetTableViewDelegate() {
    
        XCTAssertNotNil(sut.tableView!.delegate)
        XCTAssertTrue(sut.tableView!.delegate is ItemListDataProvider)
    
    }
    
    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() {
        
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
    
    }
    
    func testItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as? UIViewController, sut)
    }
    
    func performSetup() {
       
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = sut
        
        sut.performSelector(addButton.action, withObject: addButton)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        inputViewController = sut.presentedViewController as! InputViewController
    }
    
    func testAddItem_PresentsAddItemViewController() {
        
        performSetup()
        
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        
        performSetup()  
        
        guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func testViewWillAppear_ReloadsData() {
       
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        // Add tests here
        
    }
    
    func testItemSelectedNotification_PushesDetailVC() {
        
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = mockNavigationController
        
        _ = sut.view
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            "ItemSelectedNotification",
            object: self,
            userInfo: ["index": 1])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return }
        
        guard let detailItemManager = detailViewController.itemInfo?.0 else { XCTFail(); return }
        
        guard let index = detailViewController.itemInfo?.1 else { XCTFail(); return }
        
        _ = detailViewController.view
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }
}


extension ItemListViewControllerTests {
    class MockNavigationController : UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
