//
//  RestaurantinforView.swift
//  Final Project
//
//  Created by 张水鉴 on 7/31/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import MapKit

class RestaurantinforView : UIViewController, MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputdata()
    }
    
    ///Mark: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].rowCount
    }
    
    ///Mark: fill the cell in tableview by reference .type in each class
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section]
        switch item.type{
            case .nameandpicture:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "nameandphoto", for: indexPath) as? pictureAndname{
                    cell.data = item
                    return cell
                    }
            
            case .address:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "address", for: indexPath) as? address{
                    cell.data = item
                    return cell
                }
            case .phone:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "phone", for: indexPath) as? phone{
                    cell.data = item
                    return cell
                }
            case .menu:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as? menu{
                    cell.data = item
                    return cell
            }
            case .comments:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as? comments{
                    cell.data = item
                    return cell
            }
    }
        return UITableViewCell()
    }
    
    ///Mark: prepare to segue to MenuView or commentView and transmit the result_restaurant
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "tomenu"{
            let Controller = segue.destination as! UINavigationController
            let MenuView = Controller.topViewController as! MenuView
            MenuView.restaurant = result_restaurant
        
        }
        if segue.identifier == "tocomment"{
            let Controller = segue.destination as! UINavigationController
            let commentController = Controller.topViewController as! commentView
            commentController.result_restaurant = result_restaurant
        }
    }
    
    
    ///Mark: phone cell can connect to the user phone calls
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.section].type == .phone{
            let url : NSURL = URL(string: "TEL://"+result_restaurant.phone!)! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.textLabel?.textColor = UIColor.cyan
        }
    }
    
    
    ///Mark:IBAction
    
    ///Mark: back to last page
    @IBAction func modaldidfinish(segue : UIStoryboardSegue){
        
    }
    
    ///Mark: Map to navigate the address
    @IBAction func map(_sender:Any){
        let latitude : CLLocationDegrees = result_restaurant.latitude
        let longtitude : CLLocationDegrees = result_restaurant.longtitude
        let regionDistance : CLLocationDistance = 1000
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longtitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = result_restaurant.name
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    ///Mark: input data for TableView, Applying different class for load data and append to array
    func inputdata(){
        let nameandpicture = ProfileNameandpicture(picture: result_restaurant.image!, name: result_restaurant.name!)
        let address = profileaddress(address: result_restaurant.address!)
        let phone = profilephone(phone: result_restaurant.phone!)
        let menu = profilemenu(menu: "Menu")
        let comments = profilecomments(comments: "Comments")
        
        data.append(nameandpicture)
        data.append(address)
        data.append(phone)
        data.append(menu)
        data.append(comments)
    }
    
    ///Mark: IBOutlet
    @IBOutlet weak var mapbutton: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    
    ///Mark: Properties array for store element in each cell in tableview
    var data = Array<ProfileViewModelItem>()
    
    ///Mark:Properties for Coredata
    var result_restaurant : Restaurant!
}
