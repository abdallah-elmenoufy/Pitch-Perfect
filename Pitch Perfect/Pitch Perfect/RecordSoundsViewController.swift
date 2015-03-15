//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abdallah ElMenoufy on 3/7/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    
    @IBAction func recordAudio(sender: UIButton) {
        // Display a label "recording in progress" when button is tapped
        // Disable record button
        // Show the stop and pause buttons
        
        recordingLabel.text = "recording in progress"
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Initiate a recording session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Prepare for recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording did not finish successfully!")
            recordButton.enabled = true
            stopButton.hidden = true

        }
     }
         
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
            
    }
  
    @IBAction func pauseRecording(sender: UIButton) {
        // Pause the recording session
        audioRecorder.pause()
        pauseButton.enabled = false
        resumeButton.hidden = false
        resumeButton.enabled = true
        recordingLabel.text = "recording puased!"
    }
    
    
    @IBAction func resumeRecording(sender: UIButton) {
        // Resume the same recording session
        audioRecorder.record()
        resumeButton.enabled = false
        pauseButton.enabled = true
        recordingLabel.text = "resume recording"
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        // Hide the "recoding in progress" label when button is tapped
        recordingLabel.hidden = true
        recordButton.enabled = true
        
        
        // Stop recording and end recording session
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        // Hide the stop button
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to start recording"
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

