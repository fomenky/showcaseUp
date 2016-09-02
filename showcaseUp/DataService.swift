//
//  DataService.swift
//  showcaseUp
//
//  Created by AceGod on 9/1/16.
//  Copyright © 2016 AceGod. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    let BASE_URL: String = "showcase-myapps.firebaseio.com"

    static let instance = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference()
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
}
