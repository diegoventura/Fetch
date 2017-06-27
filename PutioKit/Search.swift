//
//  Search.swift
//  Fetch
//
//  Created by Stephen Radford on 08/08/2015.
//  Copyright (c) 2015 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import RealmSwift

open class Search {

    /// The search term
    open let term: String
    
    /// The search delegate
    open var delegate: SearchDelegate?
    
    /// Search results
    open var results: [File] = []
    
    public init(term: String) {
        self.term = term
    }
    
    /// Search Put.io
    open func search(_ sender: UIViewController) {
        
        let t = term.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        Files.fetchWithURL("\(Putio.api)files/search/\(t!)/page/-1", params: ["oauth_token": "\(Putio.accessToken!)"], sender: sender) { files in
            self.results = files
            self.delegate?.searchCompleted(results: self.results)
        }
        
    }
    

}
