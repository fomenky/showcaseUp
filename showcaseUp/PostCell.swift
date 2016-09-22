//
//  PostCell.swift
//  showcaseUp
//
//  Created by AceGod on 9/2/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeReference: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // This can only be done from code for tableViewCells
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?){
        self.post = post
        likeReference = DataService.instance.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            
            if img != nil{
                self.showcaseImg.image = img // Show img from Cache
            } else{
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, err: NSError?) in
                    
                    if err == nil{
                        let img = UIImage(data: data!)
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img!, forKey: self.post.imageUrl!)
                    }
                    
                })
            }
            
        }else{
            self.showcaseImg.hidden = true
        }
        
        likeReference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let likesDoesNotExist = snapshot.value as? NSNull /*Firebase nil */ {
                // This means we haven't liked a specific post
                self.likeImage.image = UIImage(named: "heart-empty")
            }else{
                self.likeImage.image = UIImage(named: "heart-full")
            }
        
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer)  {
        
        likeReference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let likesDoesNotExist = snapshot.value as? NSNull /*Firebase nil */ {
                // This means we haven't liked a specific post
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeReference.setValue(true)
            }else{
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeReference.removeValue()
            }
            
        })
    }
    
    
    
    
}
