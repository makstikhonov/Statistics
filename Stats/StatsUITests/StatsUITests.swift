//
//  StatsUITests.swift
//  StatsUITests
//
//  Created by max on 22.07.2022.
//

import XCTest

class StatsUITests: XCTestCase {

    override func setUpWithError() throws {
   
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        func testMoveThroughtAllScreens() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
            app/*@START_MENU_TOKEN@*/.buttons["My country"]/*[[".segmentedControls.buttons[\"My country\"]",".buttons[\"My country\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 2)
            app/*@START_MENU_TOKEN@*/.buttons["My country"]/*[[".segmentedControls.buttons[\"My country\"]",".buttons[\"My country\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()


            let elementsQuery = app.scrollViews.otherElements
            let collectionViewsQuery = elementsQuery.collectionViews

            collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Select a country from the list"]/*[[".cells.staticTexts[\"Select a country from the list\"]",".staticTexts[\"Select a country from the list\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*//*@START_MENU_TOKEN@*/.buttons["My country"]/*[[".segmentedControls.buttons[\"My country\"]",".buttons[\"My country\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 2)
            collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Select a country from the list"]/*[[".cells.staticTexts[\"Select a country from the list\"]",".staticTexts[\"Select a country from the list\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

            elementsQuery.navigationBars["Stats.ListOfCountriesView"].searchFields["Type country`s name"].tap()
            elementsQuery.navigationBars["Stats.ListOfCountriesView"].searchFields["Type country`s name"].typeText("Russia")
            elementsQuery.navigationBars["Stats.ListOfCountriesView"].searchFields["Type country`s name"]/*@START_MENU_TOKEN@*/.buttons["My country"]/*[[".segmentedControls.buttons[\"My country\"]",".buttons[\"My country\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 2)

            collectionViewsQuery.cells.children(matching: .other).element(boundBy: 1).tap()

            XCTAssert( collectionViewsQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Country: Russian Federation")/*[[".cells.containing(.staticText, identifier:\"New confirmed: 5631\\nTotal confirmed: 18234870\\nNew deaths: 36\\nTotal deaths: 374259\\nNew recovered: 0\\nTotal recovered: 0\\nDate: 2022\/07\/22\")",".cells.containing(.staticText, identifier:\"Country: Russian Federation\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 1).waitForExistence(timeout: 2.0))
                                                
     }

}
