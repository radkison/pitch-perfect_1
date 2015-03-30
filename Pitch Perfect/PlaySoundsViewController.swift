//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Robert Adkison on 3/15/15.
//  Copyright (c) 2015 Robert Adkison. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //create global audio player variable
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create instance of audio player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        //enable the ability to use the rate property
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error:nil)
    }
    
    func playAudio(rate: Float){
        
        //stop player before playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        
        //set the rate
        audioPlayer.rate = rate
        //reset to the begining of the audio
        audioPlayer.currentTime = 0.0
        //play
        audioPlayer.play()
        
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        
        playAudio(0.5)
    }

    
    @IBAction func playFastAudio(sender: UIButton) {
        
        playAudio(1.5)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        //stop  audio player
        audioPlayer.stop()
        
        //Stop and rest Audio Engine
        audioEngine.stop()
        audioEngine.reset()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        //stop the audio player
        audioPlayer.stop()
        //stop and reset the Audio Engine
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Create the AVAudioUnitTimePitch object and set the pitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //Attach the audioPlayerNode to the Audio Engine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        //Attach AVAudioUnitTimePitch to the Audio Engine
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }


}
