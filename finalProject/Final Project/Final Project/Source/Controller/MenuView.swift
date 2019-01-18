//
//  CategoryView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/1/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import CoreData
import UIKit

class MenuView : UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate{
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        result_menu = restaurantservice.shared.menu(for: restaurant)
        result_menu?.delegate = self
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
    //MARK: Deinitialization
    deinit {
        for observerToken in observerTokens {
            NotificationCenter.default.removeObserver(observerToken)
        }
    }
    
    ///Mark: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = self.resultsController()?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCell
        let values = self.resultsController()!.object(at: indexPath)
        cell.Label?.text = values.category
        if indexPath.item > colorCell.count - 1{
            let Index = indexPath.item - (colorCell.count - 1)
            cell.Label.backgroundColor = colorCell[Index]
        }
        else{
            cell.Label.backgroundColor = colorCell[indexPath.item]
            
        }
        return cell
    }
    
    ///Mark: prepare to segue to MenuView or commentView and transmit the result_menu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            let Controller = segue.destination as! CategoryView
            let indexPath = CollectionView.indexPathsForSelectedItems!
            Controller.menu = self.resultsController()!.object(at: indexPath[0])
            CollectionView.deselectItem(at: indexPath[0], animated: true)
            
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    ///Mark: SearchBar same as RestaurantView
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            searchresult_menu = nil
            
            view.endEditing(true)
        }
        else{
            isSearching = true
            searchresult_menu = restaurantservice.shared.menu(for: restaurant, searchTerm: searchText)
        }
        
        CollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    
    private func resultsController() -> NSFetchedResultsController<Menu>? {
        guard !isSearching else {
            return searchresult_menu
        }
        
        return result_menu
    }
    
    
    //MARK : Properties(coredata, searchBar, Keyboard)
    var restaurant : Restaurant!
    var result_menu : NSFetchedResultsController<Menu>?
    var searchresult_menu : NSFetchedResultsController<Menu>?
    var isSearching = false
    
    // MARK: Properties (Private)
    private var observerTokens = Array<Any>()
    private var colorCell : Array<UIColor> = [UIColor.blue,UIColor.brown,UIColor.red,UIColor.green,UIColor.darkGray,UIColor.orange]
    
    // MARK: Properties (IBOutlet)
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    }
    ///Mark: reloadData
    extension MenuView : NSFetchedResultsControllerDelegate{
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            CollectionView.reloadData()
        }
    }

