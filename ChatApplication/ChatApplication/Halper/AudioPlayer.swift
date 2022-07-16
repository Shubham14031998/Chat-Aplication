//
//  SKAudioRecordPlay.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//


import UIKit
import AVFoundation
import AVKit

class SKAudioRecordPlay: NSObject, AVAudioRecorderDelegate {
    
    static let shared = SKAudioRecordPlay()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVPlayer!
    var timeDuration: Double = 0.0
    var totalTimeDuration: Double = 0.0
    var audioUrl:URL?
    var timer: Timer?
    var updateProgressBar:((Float, Float) -> ())? = nil
    
    
    //MARK: - LifeCycle -
    
    private override init() {
        super.init()
        self.setupRecordingSession()
    }
    
    
    func playingTime(_ timerHandler:((Float) -> ())? = nil) {
        let progress = ((Float(self.timeDuration)/Float(self.totalTimeDuration)))/1.0
        timerHandler?(progress > 0.0 ? progress : 0.0)
    }
    
    fileprivate func setupRecordingSession() {
        print(#function)
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    print(allowed ? "Allowed" : "Failed")
                }
            }
        } catch {
            print("Failed!!!!!!")
        }
    }
    
    func playAudio(with urlInString: String) {
        guard let urlFotmatted = URL.init(string: urlInString) else {
            print("************\n*******\nAudio url failed\n************\n*******\n")
            return
        }
        print(urlFotmatted)
        audioPlayer =  AVPlayer(url: urlFotmatted)
        audioPlayer.volume = 10.0
        audioPlayer.play()
        self.timeDuration       = 0.0
        self.totalTimeDuration  = 0.0
        print("************\n*******\nAudio playing with \n************\n*******\n\(urlInString)")
        audioPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
                                            queue: DispatchQueue.main,
                                            using: { (time) in
            if self.audioPlayer != nil {
                let timer : Float64 = CMTimeGetSeconds(self.audioPlayer.currentTime())
                self.updateProgressBar(time: Float(timer))
            }
        })
    }
    
    func stopPlayer() {
        if (self.audioPlayer) != nil {
            self.audioPlayer.pause()
            self.audioPlayer = nil
        }
        
        self.timeDuration       = 0.0
        self.totalTimeDuration  = 0.0
    }
    
    
    func updateProgressBar(time: Float) {
        if self.audioPlayer.status == .readyToPlay{
            print("timeDuration",time)
            let duration = CMTimeGetSeconds((self.audioPlayer.currentItem?.duration)!)
            let finalTime = time/Float(duration)
            self.totalTimeDuration = duration
            self.updateProgressBar?(floor(time),finalTime)
        }
        
    }
    
    func startRecording() {
        self.finishRecording()
        let timeStamp = DateFormatter.localizedString(from: Date(),
                                                      dateStyle: .full,
                                                      timeStyle: .full)
        let formattedTime = timeStamp.replacingOccurrences(of: " ", with: "")
        let name = formattedTime.appending(".m4a")
        let filePath = getDocumentsDirectory().appendingPathComponent(name)
        self.audioUrl = filePath as URL
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording()
        }
        
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(self.updateTime),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording() {
        self.timer?.invalidate()
        if audioRecorder != nil {
            audioRecorder.stop()
        }
        audioRecorder = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    @objc func updateTime(_ timerHandler:((String) -> ())? = nil) {
        if audioRecorder != nil {
            let minutes = floor(audioRecorder.currentTime/60)
            let seconds = audioRecorder.currentTime - (minutes * 60)
            let time = String(format: "%.f", minutes) + ":" + String(format: "%.f", seconds)
            timerHandler?(time)
        }
    }
}
