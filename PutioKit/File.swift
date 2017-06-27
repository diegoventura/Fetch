//
//  File.swift
//  Fetch
//
//  Created by Stephen Radford on 17/05/2015.
//  Copyright (c) 2015 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

open class File: Object {
   
    open dynamic var id: Int = 0
    open dynamic var name: String?
    open dynamic var size: Int64 = 0
    open dynamic var icon: String?
    open dynamic var content_type: String?
    open dynamic var has_mp4 = false
    open dynamic var parent_id: Int = 0
    open dynamic var subtitles: String?
    open dynamic var accessed = false
    open dynamic var screenshot: String?
    open dynamic var is_shared = false
    open dynamic var start_from: Float64 = 0
    open dynamic var parent: File?
    open dynamic var type: String?
    open dynamic var created_at: String?
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Delete File
    
    open func destroy() {
        Putio.networkActivityIndicatorVisible(true)
        
        let params = ["oauth_token": "\(Putio.accessToken!)", "file_ids": "\(id)"]
        
        Alamofire.request("\(Putio.api)files/delete", method: .post, parameters: params)
            .responseJSON { response in
                Putio.networkActivityIndicatorVisible(false)
                if response.result.isFailure {
                    print(response.result.error ?? "")
                }
        }
    }
    
    
    open class func destroyIds(_ ids: [Int]) {
        Putio.networkActivityIndicatorVisible(true)
        
        let stringIds: [String] = ids.map { String($0) }
        
        let params: [String:AnyObject] = ["oauth_token": Putio.accessToken! as AnyObject, "file_ids": stringIds.joined(separator: ",") as AnyObject]
        
        Alamofire.request("\(Putio.api)files/delete", method: .post, parameters: params)
            .responseJSON { response in
                Putio.networkActivityIndicatorVisible(false)
                if response.result.isFailure {
                    print(response.result.error ?? "")
                }
        }
    }
    
    // MARK: - Convert to MP4
    
    open func convertToMp4() {
        Putio.networkActivityIndicatorVisible(true)
        
        let params = ["oauth_token": "\(Putio.accessToken!)"]
        
        Alamofire.request("\(Putio.api)files/\(id)/mp4", method: .post, parameters: params)
            .responseJSON { response in
                Putio.networkActivityIndicatorVisible(false)
                if response.result.isFailure {
                    print(response.result.error ?? "")
                }
        }
    }
    
    // MARK: - Save the time
    
    open func saveTime() {
        Putio.networkActivityIndicatorVisible(true)
        
        let params: [String:AnyObject] = ["oauth_token": "\(Putio.accessToken!)" as AnyObject, "time": start_from as AnyObject]
        
        Alamofire.request("\(Putio.api)files/\(id)/start-from/set", method: .post, parameters: params)
            .responseJSON { _ in
                print("time saved")
                Putio.networkActivityIndicatorVisible(false)
            }
    }
    
    // MARK: - Rename
    
    open func renameWithAlert(_ alert: UIAlertController) {
        Putio.networkActivityIndicatorVisible(true)
        
        let textField = alert.textFields![0] 
        name = textField.text!
        
        let params: [String:AnyObject] = ["oauth_token": "\(Putio.accessToken!)" as AnyObject, "file_id": id as AnyObject, "name": name! as AnyObject]
        
        Alamofire.request("\(Putio.api)files/rename", method: .post, parameters: params).responseJSON { _ in
            Putio.networkActivityIndicatorVisible(false)
        }
    }
    
    // MARK: - Move
    
    open func moveTo(_ parentId: Int) {
        Putio.networkActivityIndicatorVisible(true)
        
        let params: [String:AnyObject] = ["oauth_token": "\(Putio.accessToken!)" as AnyObject, "file_ids": id as AnyObject, "parent_id": parentId as AnyObject]
        
        Alamofire.request("\(Putio.api)files/move", method: .post, parameters: params)
            .responseJSON { _ in
                Putio.networkActivityIndicatorVisible(false)
            }
    }
    
    open func getTime(_ callback: @escaping () -> Void) {
        
        let params = ["oauth_token": "\(Putio.accessToken!)", "start_from": "1"]
        
        Alamofire.request("\(Putio.api)files/\(id)", method: .get, parameters: params)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    if let time = json["file"]["start_from"].double {
                        self.start_from = time
                    }
                }
                
                callback()
            }
    }
    
    open class func getFileById(_ id: String, callback: @escaping (File) -> Void) {
        
        let params = ["oauth_token": "\(Putio.accessToken!)", "start_from": "1"]
        
        Alamofire.request("\(Putio.api)files/\(id)", method: .get, parameters: params)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    
                    let subtitles = ""
                    let accessed = ( json["file"]["first_accessed_at"].null != nil ) ? false : true
                    let start_from = ( json["file"]["start_from"].null != nil ) ? 0 : json["file"]["start_from"].double!
                    let has_mp4 = (json["file"]["is_mp4_available"].bool != nil) ? json["file"]["is_mp4_available"].bool! : false
                    
                    let file = File()
                    file.id = json["file"]["id"].int!
                    file.name = json["file"]["name"].string!
                    file.size = json["file"]["size"].int64!
                    file.icon = json["file"]["icon"].string!
                    file.content_type =  json["file"]["content_type"].string!
                    file.has_mp4 = has_mp4
                    file.parent_id = json["file"]["parent_id"].int!
                    file.subtitles = subtitles
                    file.accessed = accessed
                    file.screenshot = json["file"]["screenshot"].string
                    file.is_shared = json["file"]["is_shared"].bool!
                    file.start_from = start_from
                    file.created_at = json["file"]["created_at"].string
                    callback(file)
                    
                }
            }
    }
    
}
