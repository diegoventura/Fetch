//
//  TVSeason.swift
//  Fetch
//
//  Created by Stephen Radford on 13/10/2015.
//  Copyright © 2015 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import RealmSwift

open class TVSeason: Object {
    
    open dynamic var id: Int = 0
    
    open dynamic var number: Int = 0
    
    /// Episodes of the tv season
    open let episodes = List<TVEpisode>()
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
}
