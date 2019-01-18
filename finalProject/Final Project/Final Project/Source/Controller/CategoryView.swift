//
//  CategoryView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/1/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import CoreData
import UIKit

class CategoryView : UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        result_category = restaurantservice.shared.category(for: menu)
        result_category?.delegate = self
        SearchBar.delegate = self
        SearchBar.returnKeyType = UIReturnKeyType.done
        SearchBar.accessibilityIdentifier = "search"
        
        let willShowObserverToken = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] in
            self.adjustSafeArea(forWillShowKeyboardNotification: $0)
        }
        let willHideObserverToken = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] in
            self.adjustSafeArea(forWillHideKeyboardNotification: $0)
        }
        observerTokens += [willShowObserverToken, willHideObserverToken]
        
    }
    // MARK: Deinitialization
    deinit {
        for observerToken in observerTokens {
            NotificationCenter.default.removeObserver(observerToken)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? category
        
        let values = self.resultsController()!.object(at: indexPath)
        cell?.label1.text = values.name_food
        cell?.label2.text = "$ \(values.cost)"
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isSearching{
        if let sections = result_category?.sections {
            let currentSection = sections[section]
            return currentSection.name
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.textLabel?.textColor = UIColor.blue
        }
    }
    
    ///Mark: SectionIndex at the right side in the screen
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !isSearching{
        if let sections = resultsController()?.sections {
            for section in sections{
                index_array.append(section.name)
                
            }
            return index_array
        }
        }
        return nil
    }
    
    ///Mark: SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            searchresult_category = nil
            
            view.endEditing(true)
        }
        else{
            isSearching = true
            searchresult_category = restaurantservice.shared.category(for: menu, searchTerm: searchText)
        }
        
        tableview.reloadData()
    }
    
    private func resultsController() -> NSFetchedResultsController<Category>? {
        guard !isSearching else {
            return searchresult_category
        }
        
        return result_category
    }
    
    //MARK : Properties(coredata, searchBar, Keyboard)
    var menu : Menu!
    var result_category : NSFetchedResultsController<Category>?
    var searchresult_category : NSFetchedResultsController<Category>?
    var isSearching = false
    
    // MARK: Properties (Private)
    private var observerTokens = Array<Any>()
    
    var index_array = Array<String>()
    // MARK: Properties (IBOutlet)
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
}
///Mark: reloadData
extension CategoryView : NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.reloadData()
    }
}

