//
//  Task.swift
//  Calculater
//
//  Created by Nikita Yudichev on 11.05.2020.
//  Copyright © 2020 Nikita Yudichev. All rights reserved.
//

import Foundation
import Firebase

struct Task{
    
    let title   : String
    let userId  : String
    let ref     : DatabaseReference?
    var completed : Bool = false
    
    
    init(title : String, userId: String)
    {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot : DataSnapshot)
    {
        let snapshotVal = snapshot.value as! [String: AnyObject]
        title = snapshotVal["title"] as! String
        userId = snapshotVal["userId"] as! String
        completed = snapshotVal["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func conToDictionary() ->Any
    {
        return ["title": title, "userId": userId, "completed": completed]
    }
}
