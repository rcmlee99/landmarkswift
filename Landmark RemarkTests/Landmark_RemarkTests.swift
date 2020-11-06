//
//  Landmark_RemarkTests.swift
//  Landmark RemarkTests
//
//  Created by Roger Lee on 6/11/20.
//  Copyright © 2020 JR Lee. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Landmark_Remark

class Landmark_RemarkTests: XCTestCase {
    var sut: CustomPointAnnotation!
    var user: UserData!
    var viewModel1: AddNotesViewModel!
    var viewModel2: ListViewModel!

    override func setUpWithError() throws {
        super.setUp()
        let location = CLLocationCoordinate2DMake(-33.87563, 151.204841)
        user = UserData(username: "hello77", notes: "Lorem Ipsum", location: location)
        sut = CustomPointAnnotation(user: user)

        viewModel1 = AddNotesViewModel()
        viewModel2 = ListViewModel()
    }

    override func tearDownWithError() throws {
        user = nil
        sut = nil
        viewModel1 = nil
        viewModel2 = nil
        super.tearDown()
    }

    func testLandmarkObject() throws {
        XCTAssertEqual(sut.user.username, "hello77")
        XCTAssertEqual(user.notes, "Lorem Ipsum")
        XCTAssertEqual(user.location.latitude, -33.87563)
        XCTAssertEqual(user.location.longitude, 151.204841)
        
        XCTAssertEqual(viewModel1.showAlert, false)
        XCTAssertEqual(viewModel1.message, "")
        
        XCTAssertEqual(viewModel2.showAlert, false)
        XCTAssertEqual(viewModel2.errorMessage, "")
        XCTAssertEqual(viewModel2.isLoading, false)
        

        let filename = "NearbyData.json"
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        let data = try Data(contentsOf: file)
        let response = try JSONDecoder().decode(NearbyUsers.self, from: data)

        XCTAssertEqual(response.users.count, 14)
        
        let item = response.users.first
        XCTAssertEqual(item!.username, "mickey78")
        XCTAssertEqual(item!.notes, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sagittis aliquam arcu, eget accumsan est dapibus nec. Fusce lacinia aliquet nisl, a pretium tortor varius et. Quisque pretium luctus velit eu semper")
        XCTAssertEqual(item!.location.latitude, -33.951524)
        XCTAssertEqual(item!.location.longitude, 151.125198)
        
     }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
