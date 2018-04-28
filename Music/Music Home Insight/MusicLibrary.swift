//
//  MusicLibrary.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class MusicLibrary: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var songLibraryTable: UITableView!
    var arrayWithSongs: [LibraryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getMyLibrary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMyLibrary() {
        let libraryRef = Database.database().reference(withPath: "Library/XR7WkXlfi7UD5IMmOU3aBKIS43K3")
        libraryRef.queryOrdered(byChild: "artist_name").observe(.value, with: { snapshot in
            var newLibraryItem: [LibraryModel] = []
            for item in snapshot.children {
                let libraryItem = LibraryModel(snapshot: item as! DataSnapshot)
                newLibraryItem.append(libraryItem)
            }
            self.arrayWithSongs = newLibraryItem
            self.songLibraryTable.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWithSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "songInitCell"
        var cell: MusicLibraryCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MusicLibraryCell
        if cell == nil {
            tableView.register(UINib(nibName: "MusicLibraryCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MusicLibraryCell
        }

        let mediaObject = arrayWithSongs[indexPath.row]
        cell.songTitle.text = mediaObject.name
        cell.songDetails.text = mediaObject.artist

        Alamofire.request(mediaObject.artwork).responseImage { response in
            if let image = response.result.value {
                cell.songArtwork.image = image
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let mediaObject = arrayWithSongs[indexPath.row]
        let mediaPlayer = MusicPlayer()
        mediaPlayer.libraryObjectIdent = mediaObject.key
        present(mediaPlayer, animated: true, completion: nil)
    }

}
