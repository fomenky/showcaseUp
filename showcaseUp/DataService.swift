//
//  DataService.swift
//  showcaseUp
//
//  Created by AceGod on 9/1/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL: String = "showcase-myapps.firebaseio.com"

class DataService{

    static let instance = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference()
    private var _REF_USERS = FIRDatabase.database().referenceFromURL("\(BASE_URL)/users")
    private var _REF_POSTS = FIRDatabase.database().referenceFromURL("\(BASE_URL)/posts")
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        //Here is gets the uid from a specific user
        //However if there isn't a uid it will create one
        
        REF_USERS.child(uid).setValue(user)
    }
}
