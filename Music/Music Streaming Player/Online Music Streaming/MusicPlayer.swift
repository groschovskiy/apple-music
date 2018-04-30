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
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!

    @IBOutlet weak var playPauseButton: UIButton!

    var libraryObjectIdent: String!
    var mediaPlayerCore: CastCore!

    override func viewDidLoad() {
        super.viewDidLoad()

        albumArtwork.layer.cornerRadius = 5.0
        albumArtwork.clipsToBounds = true

        getLibrarySongItem()
        initSessionDelegate()
        becomeFirstResponder()

        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getLibrarySongItem() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let userRef = Auth.auth().currentUser?.uid
                let accountRef = Database.database().reference(withPath: "Library/\(userRef!)/\(self.libraryObjectIdent!)")
                accountRef.queryOrdered(byChild: "song_name").observe(.value, with: { snapshot in
                    let dataSnapshot = snapshot.value as? [String : AnyObject] ?? [:]
                    self.songName.text = dataSnapshot["song_name"] as? String
                    self.artistName.text = dataSnapshot["artist_name"] as? String
                    self.initBroadcasting(url: dataSnapshot["stream_url"] as! String)
                    
                    Alamofire.request(dataSnapshot["album_artwork"] as! String).responseImage { response in
                        if let image = response.result.value {
                            self.albumArtwork.image = image
                        }
                    }
                    
                    self.castButtonStateSwitch()
                })
            } else {
                let accountRef = Database.database().reference(withPath: "Welcome/Songs/\(self.libraryObjectIdent!)")
                accountRef.queryOrdered(byChild: "song_name").observe(.value, with: { snapshot in
                    let dataSnapshot = snapshot.value as? [String : AnyObject] ?? [:]
                    self.songName.text = dataSnapshot["song_name"] as? String
                    self.artistName.text = dataSnapshot["artist_name"] as? String
                    self.initBroadcasting(url: dataSnapshot["stream_url"] as! String)
                    
                    Alamofire.request(dataSnapshot["album_artwork"] as! String).responseImage { response in
                        if let image = response.result.value {
                            self.albumArtwork.image = image
                        }
                    }
                    
                    self.castButtonStateSwitch()
                })
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEventType.remoteControl {
            if event!.subtype == UIEventSubtype.remoteControlPause {
                mediaPlayerCore.pauseMusicCast()
            } else if event!.subtype == UIEventSubtype.remoteControlPlay {
                mediaPlayerCore.playMusicCast()
            }
        }
    }

    func initBroadcasting(url: String) {
        mediaPlayerCore = CastCore()
        mediaPlayerCore.mediaStreaming(streamURL: url)
    }

    func castButtonStateSwitch() {
        if (mediaPlayerCore!.mediaCast!.rate > 0) {
            playPauseButton.setImage(UIImage(named: "player_pause_icon"), for: UIControlState.normal)
        } else {
            playPauseButton.setImage(UIImage(named: "player_play_icon"), for: UIControlState.normal)
        }
    }

    func initSessionDelegate() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
    }

    @IBAction func closeController(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func previousSong(sender: UIButton) {
        
    }

    @IBAction func playPauseHandler(sender: AnyObject) {
        if (mediaPlayerCore.mediaCast.rate > 0) {
            mediaPlayerCore.pauseMusicCast()
        } else {
            mediaPlayerCore.playMusicCast()
        }
        castButtonStateSwitch()
    }

    @IBAction func nextSong(sender: UIButton) {
        
    }
    
    @IBAction func likeCurrentSong(sender: UIButton) {
        if (mediaPlayerCore!.mediaCast!.rate > 0) {
            playPauseButton.setImage(UIImage(named: "player_pause_icon"), for: UIControlState.normal)
        } else {
            playPauseButton.setImage(UIImage(named: "player_play_icon"), for: UIControlState.normal)
        }
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
