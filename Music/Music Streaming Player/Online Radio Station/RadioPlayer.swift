//
//  RadioPlayer.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase
import MediaPlayer

class RadioPlayer: UIViewController {

    var stationDeclarationObject: String!
    var streamCoreEvent: CastCore!

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var stationDetails: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stationArtwork: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        stationArtwork.layer.cornerRadius = 5.0
        stationArtwork.clipsToBounds = true

        getStationMetainfo()
        initSessionDelegate()
        becomeFirstResponder()

        UIApplication.shared.beginReceivingRemoteControlEvents()
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
                streamCoreEvent.pauseMusicCast()
            } else if event!.subtype == UIEventSubtype.remoteControlPlay {
                streamCoreEvent.playMusicCast()
            }
        }
    }
    
    func getStationMetainfo() {
        let accountRef = Database.database().reference(withPath: "Radio/\(stationDeclarationObject!)")
        accountRef.queryOrdered(byChild: "like_count").observe(.value, with: { snapshot in
            let dataSnapshot = snapshot.value as? [String : AnyObject] ?? [:]
            self.stationName.text = dataSnapshot["station_name"] as? String
            self.stationDetails.text = dataSnapshot["station_status"] as? String
            self.launchStreamingEvent(url: String(format: "%@", dataSnapshot["broadcast_url"] as! String))
        })
    }

    // MARK: - Button Action Events

    @IBAction func playPauseEvent(sender: UIButton) {
        if (streamCoreEvent.mediaCast.rate > 0) {
            streamCoreEvent.pauseMusicCast()
        } else {
            streamCoreEvent.playMusicCast()
        }
        changePlayButton()
    }

    // MARK: - Button Action Events

    func launchStreamingEvent(url: String) {
        streamCoreEvent = CastCore()
        streamCoreEvent.mediaStreaming(streamURL: url)
    }

    func changePlayButton() {
        if (streamCoreEvent!.mediaCast!.rate > 0) {
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
        streamCoreEvent.stopMusicCast()
        dismiss(animated: true, completion: nil)
    }

}
