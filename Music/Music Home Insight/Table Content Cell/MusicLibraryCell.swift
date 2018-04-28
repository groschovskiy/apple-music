//
//  MusicLibraryCell.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit

class MusicLibraryCell: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songDetails: UILabel!
    @IBOutlet weak var songArtwork: UIImageView!
    @IBOutlet weak var songCellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        songCellView.layer.cornerRadius = 15.0
        songCellView.clipsToBounds = true

        songArtwork.layer.cornerRadius = self.frame.height / 2.0
        songArtwork.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
