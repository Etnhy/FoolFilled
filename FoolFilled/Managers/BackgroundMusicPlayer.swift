//
//  BackgroundMusicPlayer.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import AVFoundation
import UIKit

enum BackgroundSongs: Int {
    case first
    
    
    var songName: String {
        switch self {
        case .first:
            return "background_song1"
        }
    }
}

class BackgroundMusicPlayer {
    var audioPlayer: AVAudioPlayer?

    init() {
        setupAudioPlayer(song: .first)
        setupNotifications()
    }


    private func setupAudioPlayer(song: BackgroundSongs) {
        guard let url = Bundle.main.url(forResource: song.songName, withExtension: "mp3") else {
            print("Не удалось найти файл.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer?.numberOfLoops = -1
            
            audioPlayer?.play()
        } catch {
            print("Не удалось инициализировать аудиоплеер: \(error)")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appDidEnterBackground() {
        audioPlayer?.pause()
    }

    @objc func appWillEnterForeground() {
        audioPlayer?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
