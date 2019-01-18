//
//  Final_ProjectUITests.swift
//  Final ProjectUITests
//
//  Created by 张水鉴 on 8/14/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import XCTest

class Final_ProjectUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
    
    func testCommentWorks(){
        let app = XCUIApplication()
        app.launch()
        
        ///Mark: To Comments
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("finalproject@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("11111111")
        app.buttons["Login"].tap()
        let navBar_C2 = app.navigationBars["Restaurant"]
        waitForElementToAppear(element: navBar_C2)
        app.cells.element(boundBy: 0).tap()
        app.cells.element(boundBy: 4).tap()
        
        ///Mark: Register element
        
        let showAddButton = app.navigationBars.buttons["Add"]
        let backButton = app.navigationBars.buttons["Back"]
        
        XCTAssertTrue(showAddButton.exists, "Add button should exist")
        XCTAssertTrue(backButton.exists, "Back button should exist")
        
        ///Mark: To Write and post
        showAddButton.tap()
        
        let showCancelButton = app.navigationBars.buttons["Cancel"]
        let PostButton = app.navigationBars.buttons["Post"]
        
        XCTAssertTrue(showCancelButton.exists, "Cancel button should exist")
        XCTAssertTrue(PostButton.exists, "Post button should exist")
        
        PostButton.tap()
        app.alerts["Alert"].buttons["OK"].tap()
        
        app.textViews["Text"].tap()
        app.textViews["Text"].typeText("Thumb up")
        
        PostButton.tap()
        waitForElementToAppear(element: app.navigationBars["Comments"])
        
        ///Mark: ToEdit Save and go back check edit
        let comments = app.cells.element(boundBy: 0)
        
        XCTAssertTrue(comments.staticTexts["Thumb up"].exists,"Comments should create")
        
        comments.tap()
        
        XCTAssertTrue(app.navigationBars.buttons["Save"].exists, "Save button should exist")
        app.textViews["Text"].tap()
        app.textViews["Text"].typeText("Final Project Done ")
        app.navigationBars.buttons["Save"].tap()
        app.navigationBars.buttons["Comments"].tap()
        
        XCTAssertEqual(comments.staticTexts["Thumb up"].label, "Final Project Done Thumb up","comments not conform")
    }
    
    func testRestaurantWorks(){
        let app = XCUIApplication()
        app.launch()
        
        ///Mark: to restaurant view
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("finalproject@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("11111111")
        app.buttons["Login"].tap()
        let navBar_C2 = app.navigationBars["Restaurant"]
        waitForElementToAppear(element: navBar_C2)
        
        ///Mark:Test number of cell for restaurant
        XCTAssertGreaterThan(app.cells.count, 0, "tableView should contain more than 0 cells")
        
        ///Mark: Test searchBar works
        let searchField = app.otherElements["search"].children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("Pastini")
        let cells_C2 = app.cells
        let restaurantCell = cells_C2.element(boundBy: 0)
        XCTAssertTrue(restaurantCell.staticTexts["Pastini"].exists, "Restaurant Pastini not found")
        
        ///Mark: To Information
        restaurantCell.tap()
        
        ///Mark:register button Map
        let showMapbutton = app.navigationBars.buttons["map"]
        XCTAssertTrue(showMapbutton.exists,"map button should exist")
        
        ///Mark: Test number of cell for Information
        let cells_C3 = app.cells
        XCTAssertEqual(cells_C3.count, 5, "tableView should contain five custom cells")
        
        ///Mark: To Menu
        cells_C3.element(boundBy: 3).tap()
        
        ///Mark: Same things as above
        XCTAssertGreaterThan(app.cells.count, 0, "tableView should contain more than 0 cells")
        
        searchField.tap()
        searchField.typeText("Salad")
        let cells_C4 = app.cells
        let MenuCell = cells_C4.element(boundBy: 0)
        XCTAssertTrue(MenuCell.staticTexts["Salad"].exists, "Menu Salad not found")
        
        ///Mark: To Dishes
        MenuCell.tap()
        
        ///Mark: Same things as above
        
        XCTAssertGreaterThan(app.cells.count, 0, "tableView should contain more than 0 cells")
        searchField.tap()
        searchField.typeText("Large Bistro Salad")
        let cells_C5 = app.cells
        let DishesCell = cells_C5.element(boundBy: 0)
        XCTAssertTrue(DishesCell.staticTexts["Large Bistro Salad"].exists, "Dishes Large Bistro Salad not found")
        XCTAssertTrue(DishesCell.staticTexts["$ 10.0"].exists, "Cost not found")
        
    }
    
    
    
    func testMyAccount(){
        let app = XCUIApplication()
        app.launch()
        
        ///Mark:Login
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("finalproject@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("11111111")
        app.buttons["Login"].tap()
    
        let navBar_C2 = app.navigationBars["Restaurant"]
        waitForElementToAppear(element: navBar_C2)
        
        ///test whether tab bar has two buttons, if so, tap My button
        XCTAssertEqual(app.tabBars.buttons.count, 2,"Tab Bar ashould have two button")
        app.tabBars.buttons["My"].tap()
        
        let navBar_C3 = app.navigationBars["My account"]
        waitForElementToAppear(element: navBar_C3)
        
        ///Mark: Register elements
        let showID_C3 = app.staticTexts["ID"]
        let showName_C3 = app.staticTexts["Name"]
        let showEmail_C3 = app.staticTexts["Email"]
        let showNewEmail_C3 = app.staticTexts["New email"]
        let showNewPassword_C3 = app.staticTexts["New Password"]
        let showUpdateEmailButton_C3 = app.buttons["Update User Email"]
        let showUpdatePasswordButton_C3 = app.buttons["Update Password"]
        let getNameLabel_C3 = app.staticTexts["shuijian"]
        let getEmailLabel_C3 = app.staticTexts["apple@gmail.com"]
        let NewEmailTextField_C3 = app.textFields["New_email"]
        let NewPasswordTextField_C3 = app.secureTextFields["New_Password"]
        
        XCTAssertTrue(showID_C3.exists,"ID label not exist")
        XCTAssertTrue(showName_C3.exists,"Name label not exist")
        XCTAssertTrue(showEmail_C3.exists,"Email label not exist")
        XCTAssertTrue(showNewEmail_C3.exists,"New email label not exist")
        XCTAssertTrue(showNewPassword_C3.exists,"New Password label not exist")
        XCTAssertTrue(showUpdateEmailButton_C3.exists,"Update User Email button not exist")
        XCTAssertTrue(showUpdatePasswordButton_C3.exists,"Update Password button not exist")
        XCTAssertEqual(getNameLabel_C3.label,"final project","the label to get Name is not exist")
        XCTAssertEqual(getEmailLabel_C3.label,"finalproject@test.com","the label to get Email is not exist")
        XCTAssertEqual(app.textFields.count, 1, "There should exist New Email TextField")
        XCTAssertEqual(app.secureTextFields.count, 1, "There should exist New Password SecureTextField")
        XCTAssertEqual(app.images.count, 1, "There should exist an image as the selfie")
        
        ///Mark: Test for Email and Password Textfield changed
        NewEmailTextField_C3.tap()
        NewEmailTextField_C3.typeText("finalproject@test.com")
        showUpdateEmailButton_C3.tap()
        app.alerts["Alert"].buttons["OK"].tap()
        NewEmailTextField_C3.tap()
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()

        NewEmailTextField_C3.typeText("yahoo.com")
        showUpdateEmailButton_C3.tap()
        
        let UpdateAlert = app.alerts["Alert"]
        waitForElementToAppear(element: UpdateAlert)
        UpdateAlert.buttons["OK"].tap()
        XCTAssertEqual(getEmailLabel_C3.label, "finalproject@yahoo.com","Updated Email should instead the old email")
        
        NewPasswordTextField_C3.tap()
        NewPasswordTextField_C3.typeText("1234567")
        showUpdatePasswordButton_C3.tap()
        app.alerts["Alert"].buttons["OK"].tap()
        NewPasswordTextField_C3.tap()
        NewPasswordTextField_C3.typeText("12345678")
        showUpdatePasswordButton_C3.tap()
        waitForElementToAppear(element: UpdateAlert)
        UpdateAlert.buttons["OK"].tap()
    
        ///Mark: Test New Password
        app.navigationBars.buttons["Log out"].tap()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("finalproject@yahoo.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("12345678")
        app.buttons["Login"].tap()
        
        //Mark: recover Email and Password
        waitForElementToAppear(element: navBar_C2)
        app.tabBars.buttons["My"].tap()
        waitForElementToAppear(element: navBar_C3)
        NewEmailTextField_C3.tap()
        NewEmailTextField_C3.typeText("finalproject@test.com")
        showUpdateEmailButton_C3.tap()
        
        waitForElementToAppear(element: UpdateAlert)
        UpdateAlert.buttons["OK"].tap()
        
        NewPasswordTextField_C3.tap()
        NewPasswordTextField_C3.typeText("11111111")
        showUpdatePasswordButton_C3.tap()
        waitForElementToAppear(element: UpdateAlert)
        UpdateAlert.buttons["OK"].tap()
        
        app.navigationBars.buttons["Log out"].tap()
        
        
    }
    func testRegisterLogin() {
        
        let app = XCUIApplication()
        app.launchEnvironment["UseFakeUserService"] = "true"
        app.launch()
        
        ///Mark: Register elements
        let showLoginButton_C1 = app.buttons["Login"]
        let showRegisterButton_C1 = app.buttons["Register"]
        let showEmail_C1 = app.staticTexts["Email"]
        let showpassword_C1 = app.staticTexts["Password"]
        let EmailTextField_C1 = app.textFields["Email"]
        let PasswordSecureText_C1 = app.secureTextFields["Password"]
        
        ///Mark: Test button exists and number of textfields

        XCTAssertTrue(showLoginButton_C1.exists, "The main view does not have a Login button")
        XCTAssertTrue(showRegisterButton_C1.exists, "The main view does not have a Register button")
        XCTAssertTrue(showEmail_C1.exists, "The main view does not have a Email Label")
        XCTAssertTrue(showpassword_C1.exists, "The main view does not have a Password Label")
        XCTAssertEqual(app.textFields.count, 1, "There should exist Email TextField")
        XCTAssertEqual(app.secureTextFields.count, 1, "There should exist Password SecureTextField")
        //XCTAssertEqual(app.label.count, 4,"There should exist 4 labels")
        
        ///Mark: Test alert for wrong Account Email or Password
        EmailTextField_C1.tap()
        EmailTextField_C1.typeText("apple")
        PasswordSecureText_C1.tap()
        PasswordSecureText_C1.typeText("abcdefg")
        showLoginButton_C1.tap()
        app.alerts["Error log in"].buttons["OK"].tap()
        
        ///Mark: tap to registerView
        showRegisterButton_C1.tap()
        
        ///Mark: Register elements
        let showUsername_C2 = app.staticTexts["Username"]
        let showEmail_C2 = app.staticTexts["Email"]
        let showPassowrd_C2 = app.staticTexts["Password"]
        let showRePassword_C2 = app.staticTexts["Re-enter Password"]
        let showRegisterButton_C2 = app.buttons["Register"]
        let showIhaveAccountButton_C2 = app.buttons["I have a account, let me login"]
        let showTaptochangeButton_C2 = app.buttons["Tap to change"]
        let UsernameTextField_C2 = app.textFields["Username"]
        let EmailTextField_C2 = app.textFields["Email"]
        let PasswordSecureText_C2 = app.secureTextFields["Password"]
        let RePasswordSecureText_C2 = app.secureTextFields["Re-Password"]
        
        ///Mark: Test button exists and number of textfields and image
        XCTAssertTrue(showRegisterButton_C2.exists, "The main view does not have a Register button")
        XCTAssertTrue(showIhaveAccountButton_C2.exists, "The main view does not have I have a account, let me login  button")
        XCTAssertTrue(showTaptochangeButton_C2.exists, "The main view does not have a Tap to change button")
        XCTAssertTrue(showUsername_C2.exists, "The main view does not have a Username Label")
        XCTAssertTrue(showEmail_C2.exists, "The main view does not have a Email Label")
        XCTAssertTrue(showPassowrd_C2.exists, "The main view does not have a Password Label")
        XCTAssertTrue(showRePassword_C2.exists, "The main view does not have a Re-enter Password Label")
        XCTAssertEqual(app.textFields.count, 2, "There should exist Username and Email TextField")
        XCTAssertEqual(app.secureTextFields.count, 2, "There should exist Password and Re-enter Password SecureTextField")
        XCTAssertEqual(app.images.count, 1, "There should exist an image as the selfie")
        
        
        ///Mark: func I have account button
        showIhaveAccountButton_C2.tap()
        showRegisterButton_C1.tap()
        
        ///Mark: Test alert for Tepo question of Username Email Password and Re-enter Password
        showRegisterButton_C2.tap()
        app.alerts["Alert"].buttons["OK"].tap()
        
        UsernameTextField_C2.tap()
        UsernameTextField_C2.typeText("shuijian")
        EmailTextField_C2.tap()
        EmailTextField_C2.typeText("apple")
        PasswordSecureText_C2.tap()
        PasswordSecureText_C2.typeText("11111111")
        RePasswordSecureText_C2.tap()
        RePasswordSecureText_C2.typeText("1111111")
        showRegisterButton_C2.tap()
        app.alerts["Alert"].buttons["OK"].tap()
        
        EmailTextField_C2.tap()
        EmailTextField_C2.typeText("@gmail.com")
        showRegisterButton_C2.tap()
        app.alerts["Alert"].buttons["OK"].tap()
        
        waitForElementToAppear(element: RePasswordSecureText_C2, timeout: 3)
        RePasswordSecureText_C2.tap()
        RePasswordSecureText_C2.typeText("11111111")
        
        ///Mark: Register, if no account, register and end. Otherwise, directly stop
        showRegisterButton_C2.tap()
        
    }
}
