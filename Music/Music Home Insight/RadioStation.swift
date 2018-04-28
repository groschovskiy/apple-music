//
//  RadioStation.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage

class RadioStation: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var radioListTable: UITableView!

    var stationServiceDict: [RadioModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getRadioStatioList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationServiceDict.count
    }
    
    func getRadioStatioList() {
        let serviceRef = Database.database().reference(withPath: "Radio")
        serviceRef.queryOrdered(byChild: "like_count").observe(.value, with: { snapshot in
            var newServiceItem: [RadioModel] = []
            for item in snapshot.children {
                let stationItem = RadioModel(snapshot: item as! DataSnapshot)
                newServiceItem.append(stationItem)
            }
            self.stationServiceDict = newServiceItem
            self.radioListTable.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "songInitCell"
        var cell: MusicLibraryCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MusicLibraryCell
        if cell == nil {
            tableView.register(UINib(nibName: "MusicLibraryCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MusicLibraryCell
        }
        
        let libraryObject = stationServiceDict[indexPath.row]
        cell.songTitle.text = libraryObject.name
        cell.songDetails.text = libraryObject.status

        Alamofire.request(libraryObject.artwork).responseImage { response in
            if let image = response.result.value {
                cell.songArtwork.image = image
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let stationObject = stationServiceDict[indexPath.row]
        let stationPlayer = RadioPlayer()
        stationPlayer.stationDeclarationObject = stationObject.key
        present(stationPlayer, animated: true, completion: nil)
    }
}
