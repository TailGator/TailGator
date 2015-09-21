//
//  TGUser.swift
//  TailGator
//
//  Created by Philip DesJean on 9/21/15.
//  Copyright © 2015 Philip DesJean. All rights reserved.
//

import UIKit
import Parse

class TGUser: PFUser {
    @NSManaged var facebookId : String
    @NSManaged var firstName : String
    @NSManaged var lastName : String
    @NSManaged var name : String
    @NSManaged var image : PFFile
    @NSManaged var discoverable : Bool
    
    var gender : String {
        get { return self["gender"] as? String ?? "male"}
        set { self["gender"] = newValue }
    }
    
    var age : Int {
        get { return self["age"] as? Int ?? 25 }
        set { self["age"] = newValue }
    }
    
//    var show : DatePreference {
//        get { return DatePreference(rawValue: self["show"] as? Int ?? 2)! }
//        set { self["show"] = newValue.rawValue }
//    }
    
    var displayText : String {
        return "\(firstName), \(age)"
    }
}