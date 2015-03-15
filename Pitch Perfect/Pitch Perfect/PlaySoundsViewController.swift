//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abdallah ElMenoufy on 3/7/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayerForEcho:AVAudioPlayer!
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    // Creates a funciton to combine Stop and Play functions
    func playAudio() -> () {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // Funtion to play the recordedd audio with variable pitch levels
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func snailAudio(sender: UIButton) {
        // Play the recorded audio very slow
        playAudio()
        audioEngine.reset()
        audioPlayer.rate = 0.5
    }
    
    @IBAction func rabitAudio(sender: UIButton) {
        // Play the recorded audio very fast
        playAudio()
        audioEngine.reset()
        audioPlayer.rate = 2.0
    }
    
    @IBAction func chipMuckAudio(sender: UIButton) {
        // Play the recorded audio with high pitch level
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderAudio(sender: UIButton) {
        // Play the recorded audio with low pitch level
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        // Play the recorded audio with echo effect, by creating a copy of the audioPlayer variable and play it twice back to back
        
        playAudio()
        audioEngine.reset()
        
        let delay:NSTimeInterval = 0.2
        var playtime:NSTimeInterval
        playtime = audioPlayerForEcho.deviceCurrentTime + delay
        audioPlayerForEcho.stop()
        audioPlayerForEcho.currentTime = 0
        audioPlayerForEcho.volume = 0.8
        audioPlayerForEcho.playAtTime(playtime)
        
    }
    
    @IBAction func stopPlayingAudio(sender: UIButton) {
        // Stop the audio playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayerForEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayerForEcho.enableRate = true
        
        // Do any additional setup after loading the view.
          audioEngine = AVAudioEngine()
          audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
