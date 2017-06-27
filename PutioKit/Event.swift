//
//  Event.swift
//  Fetch
//
//  Created by Stephen Radford on 08/01/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation

open class Event {
    
    /// The text that is shown on the event
    open var name: String?
    
    /// The type of event this is. We should probably show different icons etc. for this
    open var type: EventType?
    
    /// When was the event created
    open var createdAt: String? {
        didSet {
            if let string = createdAt {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:s"
                date = formatter.date(from: string)
            }
        }
    }
    
    /// Parsed NSDate when the event was created
    open var date: Date?
    
    /// The ID of the file that this event relates to
    open var fileID: Int32?
    
}

public enum EventType {
    case transferCompleted
    case fileShared
    case transferFromRSSError
    case zipCreated
}
