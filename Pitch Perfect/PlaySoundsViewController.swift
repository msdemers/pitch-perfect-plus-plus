//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew DeMers on 8/3/15.
//  Copyright (c) 2015 Matthew DeMers. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var playbackSpeed: UISlider!
    @IBOutlet weak var playbackPitch: UISlider!
    
    @IBOutlet weak var speedReset: UIButton!
    @IBOutlet weak var pitchReset: UIButton!
    
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertSpeed(sliderValue:Float) -> Float {
        return exp(log(4.0) * sliderValue)
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        playbackSpeed.setValue(playbackSpeed.minimumValue, animated: true)
        changeSpeedSlider(playbackSpeed)
        playAudioAtRateAndPitch(rate:convertSpeed(playbackSpeed.value), pitch:playbackPitch.value)
        
    }
    
    @IBAction func playAudioFast(sender: UIButton) {
        playbackSpeed.setValue(playbackSpeed.maximumValue, animated: true)
        changeSpeedSlider(playbackSpeed)
        playAudioAtRateAndPitch(rate:convertSpeed(playbackSpeed.value), pitch:playbackPitch.value)
        
    }

    @IBAction func playAudioHigh(sender: UIButton) {
        playbackPitch.setValue(playbackPitch.maximumValue, animated: true)
        changePitchSlider(playbackPitch)
        playAudioAtRateAndPitch(rate:convertSpeed(playbackSpeed.value), pitch:playbackPitch.maximumValue)
        
    }
    
    @IBAction func playAudioLow(sender: UIButton) {
        playbackPitch.setValue(playbackPitch.minimumValue, animated: true)
        changePitchSlider(playbackPitch)
        playAudioAtRateAndPitch(rate:convertSpeed(playbackSpeed.value), pitch:playbackPitch.minimumValue)
        
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }

    @IBAction func playFromSliderValues(sender: UIButton) {
        playAudioAtRateAndPitch(rate:convertSpeed(playbackSpeed.value), pitch:playbackPitch.value)
    }
    
    @IBAction func changeSpeedSlider(sender: UISlider) {
        stopAudio(stopButton)
        let speedString = NSString(format: "%.2f", convertSpeed(playbackSpeed.value))
        speedReset.setTitle(speedString as String, forState: UIControlState.Normal)
    }
    
    @IBAction func changePitchSlider(sender: UISlider) {
        stopAudio(stopButton)
        let pitchString = NSString(format: "%.0f", playbackPitch.value)
        pitchReset.setTitle(pitchString as String, forState: UIControlState.Normal)
    }
    
    @IBAction func resetNaturalSpeed(sender: UIButton) {
        playbackSpeed.setValue(0, animated: true)
        changeSpeedSlider(playbackSpeed)
    }
    
    @IBAction func resetNaturalPitch(sender: UIButton) {
        playbackPitch.setValue(0, animated: true)
        changePitchSlider(playbackPitch)
    }
    
    func playAudioAtRateAndPitch(#rate: Float, pitch: Float){
        
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeRatePitchEffect = AVAudioUnitTimePitch()
        changeRatePitchEffect.rate = rate
        changeRatePitchEffect.pitch = pitch
        audioEngine.attachNode(changeRatePitchEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: changeRatePitchEffect, format: nil)
        audioEngine.connect(changeRatePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        var session = AVAudioSession.sharedInstance()
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        audioPlayerNode.play()
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
