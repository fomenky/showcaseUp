//
//  FeedVC.swift
//  showcaseUp
//
//  Created by AceGod on 9/2/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import UIKit
import Firebase


class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    static var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 319
        
        DataService.instance.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.posts = [] // Empty the [Post]() Array first
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                for snap in snapshots
                {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        //print(post.postDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            
            cell.request?.cancel() // If image/request already exist cancel new request
            
            var img: UIImage?
            
            if let url = post.imageUrl{
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            return cell
            
        }else{
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil{
            return 150
        }else{
            return tableView.estimatedRowHeight
        }
    }
}
