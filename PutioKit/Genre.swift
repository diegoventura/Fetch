//
//  Genre.swift
//  Fetch
//
//  Created by Stephen Radford on 10/10/2015.
//  Copyright © 2015 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import RealmSwift

open class Genre: Object {
    
    /// The id of the genre
    open dynamic var id: Int = 0
    
    /// The name of the genre
    open dynamic var name: String? = nil
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
}
