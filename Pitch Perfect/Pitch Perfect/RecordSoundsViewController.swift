//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Robert Adkison on 3/8/15.
//  Copyright (c) 2015 Robert Adkison. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Hide the stop button - recording is not in progress
        stopButton.hidden = true;
        
        //enable the microphone/record button
        recordButton.enabled = true;
        
        //display the label, change the label's text
        lblRecording.hidden = false
        lblRecording.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        //display stop button when user presses the record button
        stopButton.hidden = false;
        
        //change the recording lable to Recording
        lblRecording.hidden = false;
        lblRecording.text = "Recording"
        
        //disable the record button to prevent the user from 
        //pressing the record button twice.
        recordButton.enabled = false;
        
        //Record the user's voice.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)[0] as String
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       
        if(flag)
        {
          //Save the recorded audio
          recordedAudio = RecordedAudio(nsurlFilePath: recorder.url, sTitle: recorder.url.lastPathComponent)
        
          //Move to the next scene aka perform segue
          //Note: stopRecording is the identifier name of our segue
          self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not sucessful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            
            let data = sender as RecordedAudio
            
            playSoundsVC.receivedAudio = data
            
        }
        
    }

    @IBAction func stopAudio(sender: UIButton) {
        
        lblRecording.hidden = true;
        
        //Stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }
}

