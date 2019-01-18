//
//  commentView.swift
//  Final Project
//
//  Created by 张水鉴 on 8/7/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import UIKit
import Firebase


class commentView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    ///Mark: IBOutlet
    @IBOutlet var AddButton: UIBarButtonItem!
    @IBOutlet var DoneButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    ///Mark: Properties for slipe the cell to delete comments, Array posts for saving comments and coreData
    var horizontalSwipeToEditMode : Bool = false
    var posts = [Post]()
    var result_restaurant : Restaurant!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Insert a XIB custom cell
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        view.addSubview(tableView)
        navigationItem.setRightBarButton(AddButton, animated: false)
        navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-plus-25")
        
        tableView.reloadData()
        
        observePosts()
    }
    
    ///IBAction back add and done button
    @IBAction func backbutton(_sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addbutton(_sender:Any){
        performSegue(withIdentifier: "towrite", sender: self)
    }
    
    @IBAction func donebutton(_sender:Any){
        tableView.setEditing(false, animated: true)
        
        navigationItem.setRightBarButton(AddButton, animated: true)
    }
    
    ///Mark: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell",for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }
    
    ///Mark: slipe the cell to remove comments
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove It!"
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        navigationItem.setRightBarButton(DoneButton, animated: true)
        navigationItem.rightBarButtonItem?.image = UIImage(named: "icons8-checkmark-filled-25")
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.setRightBarButton(AddButton, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let userID = Auth.auth().currentUser?.uid
            if posts[indexPath.row].author.uid == userID{
                let postsRef = Database.database().reference().child("post")
                postsRef.child(posts[indexPath.row].id).removeValue(completionBlock: {error, ref in
                    if let error = error{
                        print("Failed to delete comment",error.localizedDescription)
                    }
                    })

            }
            else{
                let myAlert = UIAlertController(title: "Alert", message: "You can't modify other's comment", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.present(myAlert, animated:true,completion:nil)
            }
            
            
        }
        
        
    }
    
    ///Prepare the sugue to write View or Edit View by either clicking the add button or click the cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "towrite"{
            let Controller = segue.destination as! UINavigationController
            let writeController = Controller.topViewController as! postcommentView
            writeController.result_restaurant = result_restaurant
        }
        
        ///Mark: transit row in the indexPath, posts Array, textdefault and Coredata
        if segue.identifier == "toEdit"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let Controller = segue.destination as! postcommentView
                Controller.textdefault = posts[indexPath.row].text
                Controller.row = indexPath.row
                Controller.posts = posts
                Controller.result_restaurant = result_restaurant
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If the table is in editing mode we let the user rename the category, otherwise select the category and
        // display its lent items
        if Auth.auth().currentUser?.uid == posts[indexPath.row].author.uid{
            performSegue(withIdentifier: "toEdit", sender: self)
        }
    }
    
    ///Mark:func to observe Posts in Write View
    func observePosts(){
        let postsRef = Database.database().reference().child("post")
        
        postsRef.observe(.value, with:  {snapshot in
            
            var temPosts = [Post]()
            
            for child in snapshot.children{
                if let childsnapshot = child as? DataSnapshot,
                    let dict = childsnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    self.result_restaurant.name == dict["restaurant"] as? String{
                        if let uid = author["uid"] as? String,
                            let username = author["username"] as? String,
                            let photoUrl = author["photoURL"] as? String,
                            let url = URL(string: photoUrl),
                            let text = dict["text"] as? String,
                            let timestamp = dict["timestamp"] as? Double{
                        
                            let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                            let post = Post(id: childsnapshot.key, author: userProfile, text: text,timestamp: timestamp, restaurant: self.result_restaurant.name!)
                            temPosts.append(post)
                            temPosts.reverse()
                }
                
                }
            }
            self.posts = temPosts
            self.tableView.reloadData()
    })
    }
}

    

