//
//  Movie.swift
//  Fetch
//
//  Created by Stephen Radford on 10/10/2015.
//  Copyright © 2015 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

open class Movie: Object, MediaType {
    
    open dynamic var id: Int = 0
    
    /// URL to the backdrop on the API
    open dynamic var backdropURL: String?
    
    /// URL to the poster on the API
    open dynamic var posterURL: String?
    
    open dynamic var title: String?
    
    open let genres = List<Genre>()
    
    open dynamic var overview: String?
    
    open dynamic var releaseDate: String?
    
    open dynamic var runtime: Float64 = 0

    open dynamic var tagline: String?
    
    open dynamic var voteAverage: Float64 = 0
    
    /// Putio Files
    open let files = List<File>()
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
    
    // MARK: - Non-realm
    
    open var poster: UIImage?
    
    /// Title to sort alphabetically witout "The"
    open var sortableTitle: String? {
        get {
            if let range = title?.range(of: "The ") {
                if range.lowerBound == title?.startIndex {
                    return title?.replacingCharacters(in: range, with: "")
                }
            }
            return title
        }
    }
    
    override open static func ignoredProperties() -> [String] {
        return ["poster"]
    }
    
}
