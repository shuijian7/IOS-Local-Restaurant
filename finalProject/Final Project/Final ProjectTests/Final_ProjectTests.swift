//
//  Final_ProjectTests.swift
//  Final ProjectTests
//
//  Created by 张水鉴 on 7/27/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import XCTest
@testable import Final_Project

class Final_ProjectTests: XCTestCase {
    
    func testcategory(){
        let result_restaurant = restaurantservice.shared.restaurant()
        
        //if no sections and no count of sections, return XCTFail
        guard let sections = result_restaurant.sections, let count = result_restaurant.sections?.count else{
            return XCTFail("wrong")
            
        }
        ///Assert if sections are greater than 0
        XCTAssertGreaterThan(count, 0,"section is smaller than 0")
        for section in sections{
            if section.numberOfObjects == 0{
                ///Assert if number of rows in each section is greater than 0
                XCTAssertGreaterThan(section.numberOfObjects, 0,"the row in this section is smaller than 0")
            }
        }
    }
    
    func testMenu(){
        let result_restaurant = restaurantservice.shared.restaurant()
        let indexPath = IndexPath(row: 0, section: 0)
        let result_menu = restaurantservice.shared.menu(for: result_restaurant.object(at: indexPath))
        
        //if no sections and no count of sections, return XCTFail
        guard let sections = result_menu.sections, let count = result_menu.sections?.count else{
            return XCTFail("wrong")
            
        }
        ///Assert if sections are greater than 0
        XCTAssertGreaterThan(count, 0,"section is smaller than 0")
        for section in sections{
            ///Assert if number of rows in each section is greater than 0
            XCTAssertGreaterThan(section.numberOfObjects, 0,"the row in this section is smaller than 0")
        }
    }
    
    func testCategory(){
        let result_restaurant = restaurantservice.shared.restaurant()
        let indexPath = IndexPath(row: 0, section: 0)
        let result_menu = restaurantservice.shared.menu(for: result_restaurant.object(at: indexPath))
        let result_category = restaurantservice.shared.category(for: result_menu.object(at: indexPath))
        
        guard let sections = result_category.sections, let count = result_category.sections?.count else{
            return XCTFail("wrong")
            
        }
        ///Assert if sections are greater than 0
        XCTAssertGreaterThan(count, 0,"section is smaller than 0")
        for section in sections{
            ///Assert if number of rows in each section is greater than 0
            XCTAssertGreaterThan(section.numberOfObjects, 0,"the row in this section is smaller than 0")
        }
    }
}
