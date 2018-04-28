//
//  MusicPlayer.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicPlayer: UIViewController {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songArtwork: UIImageView!

    @IBOutlet weak var playPauseButton: UIButton!
    
    var broadcastURL: String!
    var mediaCastPlayer: CastCore!

    override func viewDidLoad() {
        super.viewDidLoad()

        songArtwork.layer.cornerRadius = 5.0
        songArtwork.clipsToBounds = true

        initBroadcasting()
        changePlayButton()
        initDelegateSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEventType.remoteControl {
            if event!.subtype == UIEventSubtype.remoteControlPause {
                mediaCastPlayer.pauseMusicCast()
            } else if event!.subtype == UIEventSubtype.remoteControlPlay {
                mediaCastPlayer.playMusicCast()
            }
        }
    }

    func initBroadcasting() {
        mediaCastPlayer = CastCore()
        mediaCastPlayer.mediaStreaming(streamURL: "http://cdndl.zaycev.net/966467/7110856/t-fest_x_truwer_-_na_volnu_%28zaycev.net%29.mp3")
    }

    func changePlayButton() {
        if (mediaCastPlayer!.mediaCast!.rate > 0) {
            playPauseButton.setImage(UIImage(named: "player_pause_icon"), for: UIControlState.normal)
        } else {
            playPauseButton.setImage(UIImage(named: "player_play_icon"), for: UIControlState.normal)
        }
    }

    @IBAction func previousSong(sender: UIButton) {
        
    }

    @IBAction func playPauseHandler(sender: AnyObject) {
        if (mediaCastPlayer.mediaCast.rate > 0) {
            mediaCastPlayer.pauseMusicCast()
        } else {
            mediaCastPlayer.playMusicCast()
        }
        changePlayButton()
    }

    @IBAction func nextSong(sender: UIButton) {
        
    }

    func initDelegateSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
    }

    func handleInteruption(notification: NSNotification) {
        mediaCastPlayer.pauseMusicCast()
        
        let interuptionTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
        let interuptionType = AVAudioSessionInterruptionType(rawValue: UInt(interuptionTypeAsObject.uint64Value))
        
       
    }

}
