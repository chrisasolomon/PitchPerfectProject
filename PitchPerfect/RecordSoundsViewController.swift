//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Chris Solomon on 2018-03-01.
//  Copyright © 2018 Chris Solomon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
	
	var audioRecorder: AVAudioRecorder!

	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		print("viewDidLoad called")
		stopRecordingButton.isEnabled = false


	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("viewWillAppear called")
	}
	
	
	@IBAction func recordAudio(_ sender: Any) {
		configureUI(isRecording: true)

		let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = URL(string: pathArray.joined(separator: "/"))
		
		print(filePath!)
		
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
		
		try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
		audioRecorder.delegate = self
		audioRecorder.isMeteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}
	
	@IBAction func stopRecordAudio(_ sender: Any) {
		configureUI(isRecording: false)
		
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	
	// courtesy of Udacity code reviewer
	func configureUI(isRecording: Bool)
	{
		stopRecordingButton.isEnabled = isRecording // to disable the button
		recordButton.isEnabled = !isRecording // to enable the button
		recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		print("finished recording")
		
		if flag
		{
			performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
		}
		else
		{
			print("recording was not successful")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stopRecording"
		{
			let playSoundsVC = segue.destination as! PlaySoundsViewController
			let recordedAudioURL = sender as! URL
			playSoundsVC.recordedAudioURL = recordedAudioURL
		}
	}
}

