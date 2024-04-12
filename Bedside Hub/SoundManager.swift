//
//  ImageManager.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/4/24.
//

import AVFoundation
import OrderedCollections

class SoundManager: NSObject, AVAudioPlayerDelegate, ObservableObject {
    var audioPlayers = [AVAudioPlayer]()
    var categories: OrderedDictionary<String, SoundCategory> = [:]
    private var currentIndex = 0
    private var currentCategory = "System Default (all)"
    private let fadeDuration: TimeInterval = 2.0 // Duration of the fade
    private var allSounds: [String ] = []

    override init() {
        super.init()
        configureCategories()
    }

    private func configureCategories() {
        categories["Nature"] = SoundCategory(name: "Nature", soundNames: ["EveningBirds", "Birds", "Forest", "Crickets", "Nightscape", "Wind"])
        categories["Water"] = SoundCategory(name: "Water", soundNames: ["RunningWater", "ForestRain", "River", "Stream"])
        categories["Texture"] = SoundCategory(name: "Texture", soundNames: ["Uplifting", "Space", "Dreaming", "Minor"])
        categories["Melodies"] = SoundCategory(name: "Melodies", soundNames: ["Flute", "Chords", "Piano", "Piano2", "Bells", "Game"])
        categories["Indoor"] = SoundCategory(name: "Indoor", soundNames: ["Cafe", "Office", "City", "Snoring", "AirConditioner", "Fireplace"])

        categories["System Default (all)"] = SoundCategory(name: "All", soundNames:
            Array(categories.values
                .flatMap({ (category) -> [String] in
                    category.soundNames.map({ (soundName) -> String in
                        soundName
                    })
                })
            )
        )
    }

    func sounds(categoryName: String) -> [String] {
        var results : [String]
        if let category = categories[categoryName] {
            results = category.soundNames
        } else {
            results = Array(categories.values
                .flatMap({ (category) -> [String] in
                    category.soundNames.map({ (soundName) -> String in
                        soundName
                    })
                }))
        }

        return results
    }

    func stopSounds() {
        guard !audioPlayers.isEmpty else { return }
        for audioPlayer in audioPlayers {
            fadeVolume(player: audioPlayer, toVolume: 0.0, overTime: 0.7)
            // stop each one of them a bit later
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                audioPlayer.stop()
            }
        }
    }

   // Play the list of sounds in a loop
    func playSounds(categoryName: String) {
        for audioPlayer in audioPlayers {
            audioPlayer.stop()
        }
        currentCategory = categoryName
        print("Playing Sounds in category \(categoryName) with currentIndex \(currentIndex)")
        allSounds = sounds(categoryName: categoryName)
        print("Sounds are \(allSounds)")

        for fileName in allSounds {
            print("Processing sound file is \(fileName)")
            if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                print("Have sound URL \(url)")
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.delegate = self
                    player.prepareToPlay()
                    audioPlayers.append(player)
                } catch {
                    print("Error initializing audio player for file \(fileName): \(error)")
                }
            }
        }

        guard !audioPlayers.isEmpty else { return }
        playSoundAtIndex(currentIndex, categoryName: categoryName)
   }

    private func playSoundAtIndex(_ index: Int, categoryName: String) {
        let currentPlayer = audioPlayers[index]
        currentPlayer.volume = 100.0
        print("Starting sound at volume \(currentPlayer.volume) and currentIndex is \(currentIndex)")
        currentPlayer.play()
        currentIndex = (currentIndex + 1) % audioPlayers.count
        print("Adjusted currentIndex to \(currentIndex)")

        // Fade in
        fadeVolume(player: currentPlayer, toVolume: 100.0, overTime: fadeDuration)

        // Set up to fade out and switch to the next track near the end of the current track
        let delay = currentPlayer.duration - fadeDuration - 2.1 // Start fade out before the fade duration
        print("Delay before next player is \(delay)")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.fadeVolume(player: currentPlayer, toVolume: 0.0, overTime: self.fadeDuration) {
                self.playSoundAtIndex(self.currentIndex, categoryName: categoryName)
            }
        }
    }

    // Fade volume of a player
    private func fadeVolume(player: AVAudioPlayer, toVolume endVolume: Float, overTime time: TimeInterval, completion: (() -> Void)? = nil) {
        let startTime = CACurrentMediaTime()
        let startVolume = player.volume
        let updateInterval = 0.02
        
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            let elapsedTime = CACurrentMediaTime() - startTime
            if elapsedTime < time {
                let percentage = elapsedTime / time
                player.volume = startVolume + (endVolume - startVolume) * Float(percentage)
            } else {
                player.volume = endVolume
                timer.invalidate()
                completion?()
            }
        }
    }
    
    func playNext() {
        for audioPlayer in audioPlayers {
            audioPlayer.stop()
        }
        playSoundAtIndex(currentIndex, categoryName: currentCategory)
    }
    
    func nowPlaying() -> String? {
        guard !audioPlayers.isEmpty else { return nil }
        
        return audioPlayers[currentIndex - 1].url?.deletingPathExtension().lastPathComponent
    }
    
    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // This can also be used to trigger next sound, but we're handling it with a timer for fading.
    }

}

struct SoundCategory {
    let name: String
    var soundNames: [String]

    // `init` is public by default if all properties are public
    init(name: String, soundNames: [String]) {
        self.name = name
        self.soundNames = soundNames

    }
}
