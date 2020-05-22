//
//  User.swift
//  Calculater
//
//  Created by Nikita Yudichev on 11.05.2020.
//  Copyright © 2020 Nikita Yudichev. All rights reserved.
//

import Foundation
import Firebase

struct selfUser{
    
    let id : String
    let email : String
    
    init (users: User)
    {
        self.id = users.uid
        self.email = users.email!
    }
}
