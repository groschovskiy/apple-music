//
//  RadioModel.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase

class RadioModel: NSObject {

    let key: String
    let name: String!
    let status: String!
    let artwork: String!
    let ref: DatabaseReference?
    
    init(name: String, artwork: String, status: String, key: String = "") {
        self.key = key
        self.name = name
        self.artwork = artwork
        self.status = status
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["station_name"] as! String
        artwork = snapshotValue["station_logo"] as! String
        status = snapshotValue["station_status"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "station_name": name,
            "station_status": status,
            "station_logo": artwork
        ]
    }

}
