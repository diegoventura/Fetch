//
//  Feeds.swift
//  Fetch
//
//  Created by Stephen Radford on 08/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import UIKit

open class Feeds {
    
    open class func get(_ callback: @escaping ([Feed], NSError?) -> Void) {
        
        Putio.get("rss/list") { json, error in
            if let j = json {
                if let rawFeeds = j["feeds"].array {
                    
                    // Map the raw JSON to lovely models
                    let feeds: [Feed] = rawFeeds.map {
                        let json = $0.dictionary! // Forcing this so we don't get annoying optional values
                        
                        let feed = Feed()
                        feed.id = json["id"]?.int
                        feed.title = json["title"]?.string
                        feed.paused = json["paused"]?.bool
                        return feed
                    }
                    
                    callback(feeds, nil)
                    
                }
            } else {
                callback([], error)
            }
        }
        
    }

    
}
