//
//  AudioPlayerManager.swift
//  juinjang
//
//  Created by 조유진 on 5/22/24.
//

import Foundation
import AVFoundation

final class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayerManager()
    
    private override init() { 
        super.init()
    }
    
    var audioPlayer: AVPlayer?     // 음성 재생 객체
    var isPlaying = false
    var isPaused = false
    
    var recordedFiles = [URL]()
    
    // 재생 시작
    func setPlayer(recordingURL: URL) {
        audioPlayer = AVPlayer(url: recordingURL)
        audioPlayer?.actionAtItemEnd = .pause
    }
    
    func stopPlaying() {
        audioPlayer?.pause()
        audioPlayer?.seek(to: CMTime.zero)
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        isPaused = true
        isPlaying = false
    }
    
    func startPlaying() {
        audioPlayer?.play()
        isPaused = false
        isPlaying = true
    }
    
    func getCurrentTime() -> TimeInterval? {
        guard let audioPlayer else { return nil }
        let currentTime = audioPlayer.currentTime()
        return CMTimeGetSeconds(currentTime)
    }
    
    func getDuration() -> TimeInterval? {
        guard let audioPlayer, let duration = audioPlayer.currentItem?.duration else { return nil }
        print(#function, duration)
        return CMTimeGetSeconds(duration)
    }
    
    func setCurrentTime(time: TimeInterval) {
        guard let audioPlayer else { return }
        let cmTime = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        audioPlayer.seek(to: cmTime) { completed in
           if completed {
               print("Successfully seeked to time: \(time) seconds")
           } else {
               print("Failed to seek to time: \(time) seconds")
           }
       }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        isPaused = false
    }
}
