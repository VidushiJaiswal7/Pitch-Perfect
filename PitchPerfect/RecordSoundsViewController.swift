//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by VIdushi Jaiswal on 08/07/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    
    
       //Function that records the audio and stores it in a location
    @IBAction func recordAudio(_ sender: Any) {
       configureUI(recordState: true)
        let dirPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
      
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath! , settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recordState: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            let alert=UIAlertController(title: "Error", message: "Recording was not successful", preferredStyle: UIAlertControllerStyle.alert);
            show(alert, sender: self);
        }
    }
    
    
 
    // MARK : UI Functions
    func configureUI(recordState: Bool) {

        recordingLabel.text = recordState ? "Recording In Progress" : "Tap To Record"
        stopRecordingButton.isEnabled = recordState ? true : false
        recordButton.isEnabled = recordState ? false : true
        //Rafactor the lines as follows : 
        //stopRecordingButton.isEnabled = recordState
        //recordButton.isEnabled = !recordState
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"  {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}




