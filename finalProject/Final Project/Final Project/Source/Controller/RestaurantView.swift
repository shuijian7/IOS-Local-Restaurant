//
//  RestaurantView.swift
//  Final Project
//
//  Created by 张水鉴 on 7/27/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit
import CoreData
import Firebase
class RestaurantView : UIViewController , UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        result_restaurant = restaurantservice.shared.restaurant()
        result_restaurant?.delegate = self
        SearchBar.delegate = self
        SearchBar.returnKeyType = UIReturnKeyType.done
        SearchBar.accessibilityIdentifier = "search"
    }
    // MARK: Deinitialization
    deinit {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillHide,object:nil)
    }
    
    ///Mark: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        let numbersection = resultsController()?.sections?.count
        return numbersection!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.resultsController()?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        let values = self.resultsController()!.object(at: indexPath)
        cell.textLabel?.text = values.name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isSearching{
        if let sections = resultsController()?.sections {
            let currentSection = sections[section]
            return currentSection.name
            }}
        return nil
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.textLabel?.textColor = UIColor.red
        }
    }

    ///Mark: prepare the segue to RestaurantinforView and transmit the result_restaurant
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantinforSegue" {
            let Controller = segue.destination as! RestaurantinforView
            let indexPath = tableview.indexPathForSelectedRow!
            Controller.result_restaurant  = self.resultsController()!.object(at: indexPath)
            tableview.deselectRow(at: indexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    
    ///Mark: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            search_result_restaurant = nil
            
            view.endEditing(true)
        }
        else{
            isSearching = true
            search_result_restaurant = restaurantservice.shared.restaurant(searchTerm: searchText)
        }
        
        tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    ///Mark: Depends on searchBar works
    private func resultsController() -> NSFetchedResultsController<Restaurant>? {
        guard !isSearching else {
            return search_result_restaurant
        }
        
        return result_restaurant
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {}
    
    @objc func keyboardWillHide(notification: NSNotification) {}
    
    
    
    //Mark : Properties(coredata, searchBar, Keyboard)
    var result_restaurant : NSFetchedResultsController<Restaurant>?
    var search_result_restaurant : NSFetchedResultsController<Restaurant>?
    var isSearching = false
    
    // MARK: Properties (Private)
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!

}
///Mark: reloadData
extension RestaurantView : NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.reloadData()
    }
}


