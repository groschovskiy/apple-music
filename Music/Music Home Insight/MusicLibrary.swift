//
//  MusicLibrary.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit

class MusicLibrary: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var songLibraryTable: UITableView!
    var arrayWithSongs: [LibraryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "transactionListCell"
        var cell: MusicLibraryCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? MusicLibraryCell
        if cell == nil {
            tableView.register(UINib(nibName: "MusicLibraryCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MusicLibraryCell
        }
        
        //let accountObject = arrayWithSongs[indexPath.row]

        //Alamofire.request("https://logo.clearbit.com/\(accountObject.artwork!)").responseImage { response in
        //    if let image = response.result.value {
        //        cell.transactionArtwork.image = image
        //    }
        //}

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //let songObject = arrayWithSongs[indexPath.row]
    }

}
