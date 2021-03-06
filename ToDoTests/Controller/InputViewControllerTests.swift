//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by Anko Top on 28/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import XCTest

@testable import ToDo

import CoreLocation

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main",
        bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier(
        "InputViewController") as! InputViewController
        
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_HasTitleTextField() {
        
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasDateTextField() {
        
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationTextField(){
        
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasAdressTextField() {
        
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasDescriptionTextField() {
        
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasCancelButton() {
        
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func test_HasSaveButton() {
        
        XCTAssertNotNil(sut.saveButton)
    }
    
    func testSave_WithNoDataShouldFail() {
        
        sut.itemManager = ItemManager()
        sut.save()
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 0 , "Item should not have been saved")
        
    }
    
    func testSave_WithOnlyTitleFilledShouldWork() {
        sut.titleTextField.text = "Test Title"
        sut.itemManager = ItemManager()
        sut.save()
        
        XCTAssertEqual(sut.itemManager?.itemAtIndex(0).title, sut.titleTextField.text , "Item should have been saved")
    }
    
    func testSave_WithTitleAndDescriptionShouldWork(){
        sut.titleTextField.text = "Test Title"
        sut.dateTextField.text = "02/22/2016"
        sut.descriptionTextField.text = "Test Description"
        sut.itemManager = ItemManager()
        sut.save()
        
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test Title",
                                itemDescription: "Test Description",
                                timestamp: 1456095600,
                                location: nil)
        
        XCTAssertEqual(item, testItem)

    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        sut.titleTextField.text = "Test Title"
        sut.dateTextField.text = "02/22/2016"
        sut.locationTextField.text = "Office"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.itemManager = ItemManager()
        
        sut.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                    -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test Title",
                                itemDescription: "Test Description",
                                timestamp: 1456095600,
                                location: Location(name: "Office", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actionsForTarget(sut, forControlEvent: .TouchUpInside) else { XCTFail(); return}
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    // take care: this is a asynchronous call!
    func test_GeocoderWorksAsExpected() {
        
        let expectation = expectationWithDescription("Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") {
            (placemarks, error) -> Void in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqualWithAccuracy(latitude, 37.3316941, accuracy: 0.000001)
            XCTAssertEqualWithAccuracy(longitude, -122.030127, accuracy: 0.000001)
           
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()
        
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
    
}


// MARK - MOCKING
extension InputViewControllerTests {
 
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(addressString: String, completionHandler: CLGeocodeCompletionHandler) {
            
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }

    class MockInputViewController : InputViewController {
        
        var dismissGotCalled = false
        
        override func dismissViewControllerAnimated(flag: Bool,
                                                    completion: (() -> Void)?) {
            
            dismissGotCalled = true
        }
    }
    
}