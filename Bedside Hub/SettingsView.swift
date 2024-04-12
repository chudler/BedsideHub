//
//  SettingsView.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var soundManager : SoundManager
    @ObservedObject var imageManager : ImageManager
    @ObservedObject var settingsManager : SettingsManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
    HStack {
        Form {
            Section(header: Text("General Settings")) {
                Toggle("Show Seconds", isOn: $settingsManager.secondsEnabled)
                Text("Brightness")
                Slider(value: $settingsManager.brightness, in: 0...100) {
                }
                .onChange(of: settingsManager.brightness) { _, newValue in
                    settingsManager.brightness = newValue
                }
                Text("Size is \((settingsManager.scaleFactor + 1) * 100, specifier: "%.0F")")
                Slider(value: $settingsManager.scaleFactor, in: -3.0...3.0) {
                }
                .onChange(of: settingsManager.scaleFactor) { _, newValue in
                    if newValue >= -3.0 && newValue <= 3.0 {
                        settingsManager.scaleFactor = newValue
                    } else {
                        settingsManager.scaleFactor = 1.0
                    }
                }
                
            }

            Section(header: Text("Sound Settings")) {
                Toggle("Sleep Sounds", isOn: $settingsManager.sleepTimer)
                    .onChange(of: settingsManager.sleepTimer) { _, newValue in
                        if newValue {
                            soundManager.playSounds(categoryName: settingsManager.selectedSoundCategory)
                        } else {
                            soundManager.stopSounds()
                        }
                    }

                Picker("Stop Sound After", selection: $settingsManager.lullabyInterval) {
                    ForEach(SettingsManager.sleepTimerIntervals, id: \.self) { interval in
                        Text("\(settingsManager.intervalDescription(Int(interval)))")
                            .tag(interval)
                    }
                }

                Picker("Sound Theme", selection: $settingsManager.selectedSoundCategory) {
                    ForEach(soundManager.categories.keys, id: \.self)
                    { theme in
                        Text(theme).tag(theme)
                    }
                }
            }
            
            Section(header: Text("Image Settings")) {
                Toggle("Slideshow", isOn: $settingsManager.imageAutoRotateEnabled)
                Picker("Change Every", selection: $settingsManager.imageRotationInterval) {
                    ForEach(SettingsManager.intervalsInSeconds, id: \.self) { interval in
                        Text("\(settingsManager.intervalDescription(Int(interval)))")
                            .tag(interval)
                    }
                }
                Picker("Image Theme", selection: $settingsManager.selectedTheme) {
                    ForEach(imageManager.categories.keys, id: \.self)
                    { theme in
                        Text(theme).tag(theme)
                    }
                }
            }
            
            if settingsManager.sleepTimer {
                Section(header: Text("Now Playing")) {
                    Text(soundManager.nowPlaying() ?? "No sound playing")
                        .bold()
                        .foregroundColor(.white)
                    Button(action: { soundManager.playNext()}) {Text("Next") }
                }
            } else {
                
            }
            } // HStack
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
            .colorScheme(.dark)
            .navigationSplitViewStyle(.prominentDetail)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
