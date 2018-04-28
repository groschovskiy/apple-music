//
//  MusicPlayer.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import MediaPlayer

class MusicPlayer: UIViewController {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songArtwork: UIImageView!

    @IBOutlet weak var playPauseButton: UIButton!
    
    var libraryObjectIdent: String!
    var mediaCastPlayer: CastCore!

    override func viewDidLoad() {
        super.viewDidLoad()

        songArtwork.layer.cornerRadius = 5.0
        songArtwork.clipsToBounds = true

        getLibrarySongItem()
        initDelegateSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getLibrarySongItem() {
        let accountRef = Database.database().reference(withPath: "Library/XR7WkXlfi7UD5IMmOU3aBKIS43K3/\(libraryObjectIdent!)")
        accountRef.queryOrdered(byChild: "song_name").observe(.value, with: { snapshot in
            let dataSnapshot = snapshot.value as? [String : AnyObject] ?? [:]
            self.songName.text = dataSnapshot["song_name"] as? String
            self.songArtist.text = dataSnapshot["artist_name"] as? String
            self.initBroadcasting(url: dataSnapshot["stream_url"] as! String)

            Alamofire.request(dataSnapshot["album_artwork"] as! String).responseImage { response in
                if let image = response.result.value {
                    self.songArtwork.image = image
                }
            }

            self.changePlayButton()
        })
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

    func initBroadcasting(url: String) {
        mediaCastPlayer = CastCore()
        mediaCastPlayer.mediaStreaming(streamURL: url)
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
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func likeCurrentSong(sender: UIButton) {
        
    }
    
    @IBAction func showAdvancedMenu(sender: UIButton) {
        let alertController = UIAlertController(title: "Pear Music", message: "Please select your action bellow.", preferredStyle: .actionSheet)
        
        let addLibrary = UIAlertAction(title: "Add to library", style: .default) { action in

        }
        alertController.addAction(addLibrary)
        
        let shareSong = UIAlertAction(title: "Share with friends", style: .default) { action in

        }
        alertController.addAction(shareSong)

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {

        }
    }

}
