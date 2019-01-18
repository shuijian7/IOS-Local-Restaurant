//
//  restaurantservice.swift
//  Final Project
//
//  Created by 张水鉴 on 7/29/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation
import CoreData

///restaurantservice class
class restaurantservice {
    func restaurant(searchTerm: String? = nil) -> NSFetchedResultsController<Restaurant>  {
        // TODO: Update this method to utilize CoreData
        let fetchRequest : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        // Configure the request's entity, and optionally its predicate
        if let someSearchTerm = searchTerm {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", someSearchTerm)
        }
        ///sort fetchRequest with title
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category_restaurant", ascending: true)]
        
        let controller_1 : NSFetchedResultsController<Restaurant> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: "category_restaurant", cacheName: nil)
        do {
            ///perform
            try controller_1.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller_1
    }
    
    
    func menu(for restaurant: Restaurant,searchTerm: String? = nil) -> NSFetchedResultsController<Menu>  {
        // TODO: Update this method to utilize CoreData
        let fetchRequest = NSFetchRequest<Menu>(entityName: "Menu")
        
        // Configure the request's entity, and optionally its predicate
        if let someSearchTerm = searchTerm {
            fetchRequest.predicate = NSPredicate(format: "torestaurant == %@ AND category CONTAINS[cd] %@ ", restaurant, someSearchTerm)
        }
        else{
            fetchRequest.predicate = NSPredicate(format: "torestaurant == %@", restaurant)
        }
        ///sort fetchRequest with order_number
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        ///set new NSFetchedResultsController
        let controller_2 = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            ///perform
            try controller_2.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller_2
    }
    
    func category(for menu: Menu,searchTerm: String? = nil) -> NSFetchedResultsController<Category>  {
        // TODO: Update this method to utilize CoreData
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        // Configure the request's entity, and optionally its predicate
        if let someSearchTerm = searchTerm {
            fetchRequest.predicate = NSPredicate(format: "tomenu == %@ AND name_food CONTAINS[cd] %@",menu, someSearchTerm)
        }
        else{
            fetchRequest.predicate = NSPredicate(format: "tomenu == %@", menu)
        }
        ///sort fetchRequest with order_number
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "letter", ascending: true)]
        ///set new NSFetchedResultsController
        let controller_3 = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: "letter", cacheName: nil)
        do {
            ///perform
            try controller_3.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller_3
    }
    
    ///Mark: initialize
    private init() {
        persistentContainer = NSPersistentContainer(name: "Final_Project")
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            ///Read Data
            let RestaurantDataURL = Bundle.main.url(forResource: "Property List", withExtension: "plist")!
            let RestaurantData = try! Data(contentsOf: RestaurantDataURL)
            let Restaurantvalue = try! PropertyListSerialization.propertyList(from: RestaurantData, options: [], format: nil) as! Array<Dictionary<String, Any>>
            
            // TODO: Store the cat data in CoreData if it is not already present
            let fetchRequest : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            let managedObjectContext = self.persistentContainer.newBackgroundContext()
            ///guard statement for avoid repeating data in each row running in each time
            guard try! managedObjectContext.count(for: fetchRequest) == 0 else{
                return
            }
            ///perform closure for recording data from plist into context
            managedObjectContext.perform({
                for item in Restaurantvalue{
                    let restaurant = Restaurant(context: managedObjectContext)
                    restaurant.name = item[self.nameKey] as? String
                    restaurant.address = item[self.addressKey] as? String
                    restaurant.phone = item[self.phoneKey] as? String
                    restaurant.category_restaurant = item[self.restaurantcategoryKey] as? String
                    restaurant.image = item[self.imageKey] as? String
                    restaurant.latitude = item[self.latitudeKey] as! Double
                    restaurant.longtitude = item[self.longtitudeKey] as! Double
                    let menus = item[self.menuKey] as! Array<Dictionary<String,Any>>
                    for item_1 in menus{
                        let menu = Menu(context: managedObjectContext)
                        menu.category = item_1[self.categoryKey] as? String
                        let categories = item_1[self.namecategoryKey] as! Array<Dictionary<String,Any>>
                        for item_2 in categories{
                            let category = Category(context: managedObjectContext)
                            category.name_food = item_2[self.foodKey] as? String
                            category.cost = (item_2[self.costKey] as? NSNumber)?.floatValue ?? 0
                            category.letter = item_2[self.letterKey] as? String
                            category.tomenu = menu
                        }
                        menu.torestaurant = restaurant
                    }
                }
                ///save context
                try! managedObjectContext.save()
                
            })
        }
        )
    }
    
    // MARK: Private
    private let persistentContainer: NSPersistentContainer
    
    // MARK: Properties (Private, Constant)
    private let restaurantcategoryKey = "restaurant_category"
    private let nameKey = "name"
    private let addressKey = "address"
    private let phoneKey = "phone"
    private let imageKey = "image"
    private let categoryKey = "category"
    private let latitudeKey = "latitude"
    private let longtitudeKey = "longtitude"
    
    private let menuKey = "menu"
    private let namecategoryKey = "name_category"
    
    private let foodKey = "food"
    private let costKey = "cost"
    private let letterKey = "letter"
    // MARK: Properties (Static)
    static let shared = restaurantservice()
}
