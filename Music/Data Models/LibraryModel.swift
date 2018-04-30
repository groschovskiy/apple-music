//
//  LibraryModel.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase

class LibraryModel: NSObject {

    let key: String
    let name: String!
    let artist: String!
    let artwork: String!
    let ref: DatabaseReference?
    
    init(name: String, artwork: String, artist: String, key: String = "") {
        self.key = key
        self.name = name
        self.artwork = artwork
        self.artist = artist
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["song_name"] as! String
        artwork = snapshotValue["album_artwork"] as! String
        artist = snapshotValue["artist_name"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "song_name": name,
            "artist_name": artist,
            "album_artwork": artwork
        ]
    }

}
