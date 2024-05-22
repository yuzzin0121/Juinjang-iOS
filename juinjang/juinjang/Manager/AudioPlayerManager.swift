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
    
    var audioPlayer: AVAudioPlayer?     // 음성 재생 객체
    var isPlaying = false
    var isPaused = false
    
    var recordedFiles = [URL]()
    
    // 재생 시작
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            isPaused = false
        } catch {
            print("재생 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        isPaused = false
    }
}
