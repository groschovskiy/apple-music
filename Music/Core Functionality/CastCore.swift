//
//  CastCore.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class CastCore: NSObject {

    var mediaCast: AVPlayer!

    override init() {
        mediaCast = AVPlayer()
    }

    func mediaStreaming(streamURL: String) {
        let castURL = NSURL(string: streamURL)
        mediaCast = AVPlayer(url: castURL! as URL)
        initLockScreenMeta(metaURL: streamURL)
        mediaCast.play()
    }

    func playMusicCast() {
        if (mediaCast.rate == 0 && mediaCast.error == nil) {
            mediaCast.play()
        }
    }

    func pauseMusicCast() {
        if (mediaCast.rate > 0 && mediaCast.error == nil) {
            mediaCast.pause()
        }
    }

    func initLockScreenMeta(metaURL: String) {
        let localMetaInfo = metaURL.components(separatedBy: "/").split
        let localMeta = metaURL.characters.split{$0 == "/"}.map(String.init)

        let songName = localMeta[localMeta.endIndex - 1]
        let songMeta = [
            MPMediaItemPropertyTitle: songName,
            MPMediaItemPropertyArtist: "Pear Music"
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = songMeta
    }

}
