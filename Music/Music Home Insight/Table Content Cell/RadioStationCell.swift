//
//  RadioStationCell.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/30/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit

class RadioStationCell: UITableViewCell {

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var stationInfo: UILabel!
    @IBOutlet weak var stationArtwork: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        stationArtwork.layer.cornerRadius = 10.0
        stationArtwork.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
