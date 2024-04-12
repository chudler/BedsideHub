//
//  ContentView.swift
//  Bedside Hub
//
//  Created by Colin Hudler on 2/3/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var settingsManager = SettingsManager()
    @State var playingSound = false
    @State var timerManager = TimerManager()
    @State var imageManager = ImageManager()
    @State var soundManager = SoundManager()
    private var weatherService = WeatherService()
    @State private var dimmerOpacity: Double = 1.0
    @State private var totalZoom = 1.0
    @State private var showSettings = false
    @State private var weatherData = WeatherService.stubWeatherData()
    @State var currentTime = ""
    @State var currentSeconds = ""
    @State var currentDate = ""
    @State private var currentBackgroundImage: String?
    
    init() {
        
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    Group {
                        BackgroundView(imageName: currentBackgroundImage ?? "BackgroundImage/Nature/MountainMoon")
                            .onAppear {
                                setupBackgroundRotation()
                            }
                    }
                    .animation(.easeInOut(duration: 1.0), value: currentBackgroundImage)
                    Group {
                        InfoView(currentTime: $currentTime,
                                 currentDate: $currentDate,
                                 currentSeconds: $currentSeconds,
                                 weatherData: $weatherData,
                                 settingsManager: settingsManager
                        )
                        .scaleEffect(settingsManager.scaleFactor + totalZoom)
                    }
                    VStack {
                        HStack {
                            Group {
                                Button(action: {
                                    showSettings.toggle()
                                }) {
                                    Image(systemName: "gear")
                                        .padding(.all, 4)
                                        .background(Circle().fill(Color.gray.opacity(0.6)))
                                        .foregroundColor(.white)
                                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                }
                                .padding(.all, 4)
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottomTrailing)
                            }
                        }
                    }

                }
                .opacity(settingsManager.brightness / 100)
                .gesture(
                    DragGesture().onChanged { gesture in
                        let verticalMovement = gesture.translation.height
                        let adjustment = Double(-verticalMovement / 500)
                        settingsManager.brightness = max(1, min(100, settingsManager.brightness + adjustment))
                    }
                )
                .onTapGesture(count: 2) {
                    updateBackgroundImage()
                }
                .onTapGesture(count: 1) {
                   let (newIcon, newText) = weatherService.updateIcon()
                    self.weatherData = self.weatherService.replaceConditions(condition: newText, icon: newIcon)
                }
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            settingsManager.scaleFactor = value.magnification - 1
                        }
                        .onEnded { value in
                            totalZoom = applyScaleLimits(totalZoom + settingsManager.scaleFactor)
                            settingsManager.scaleFactor = 0
                        }
                )
                
            } // end of main zstack
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .background(Color.black)
        .sheet(isPresented: $showSettings) {
            SettingsView(
                soundManager: soundManager,
                imageManager: imageManager,
                settingsManager: settingsManager
        )}
        .statusBar(hidden: true)
        .onAppear {
            Task {
                UIApplication.shared.isIdleTimerDisabled = true
                updateSounds()
                await updateWeather()
                updateTime()
                updateDate()
                setupTimers()
                setupLullabyFeature()
                setupBackgroundRotation()
            }
        }
        .onReceive(settingsManager.$clockInterval) { newInterval in
            timerManager.startTimer(name: "ClockTimer", interval: newInterval) {
                updateTime()
            }
        }
        .onReceive(settingsManager.$weatherInterval) { newInterval in
            timerManager.startTimer(name: "WeatherTimer", interval: newInterval) {
                updateDate()
                Task {
                    await updateWeather()
                }
            }
        }
        .task {
            await updateWeather()
        }
        
    } // end of contentView Group
    
    private func applyScaleLimits(_ scaleValue: CGFloat) -> CGFloat {
        return min(max(scaleValue, -4.0), 5.0)
    }

    private func setupTimers() {
        timerManager.startTimer(name: "ClockTimer", interval: settingsManager.clockInterval) {
            updateTime()
        }
        timerManager.startTimer(name: "WeatherTimer", interval: settingsManager.weatherInterval) {
            updateDate()
            Task {
                await updateWeather()
            }
        }
    }

    private func setupLullabyFeature() {
        timerManager.startTimer(name: "LullabyTimer", interval: settingsManager.lullabyInterval) {
                print("Lullabye timer triggered. Stopping sounds.")
                soundManager.stopSounds()
                playingSound = false
        }
    }

    private func setupBackgroundRotation() {
        timerManager.startTimer(name: "ImageRotationTimer", interval: settingsManager.imageRotationInterval) {
            updateBackgroundImage()
        }
    }

    private func updateBackgroundImage() {
        if let image = imageManager.nextImage(forCategory: settingsManager.selectedTheme) {
            self.currentBackgroundImage = image
        }
    }
    
    private func updateSounds() {
        if !settingsManager.sleepTimer {
            if playingSound {
                print("Settings changed, stopping sounds")
                soundManager.stopSounds()
            }
        } else {
            if playingSound {
                print("Playing sound and was asked to update...")
                soundManager.stopSounds()
            }
            soundManager.playSounds(categoryName: settingsManager.selectedSoundCategory)
        }
    }

    func updateWeather() async {
        if let data = await weatherService.fetchCurrentWeather() {
            self.weatherData = data
        }
    }
    
    private func updateSeconds() {
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        currentSeconds = formatter.string(from: Date())
    }

    func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        currentTime = formatter.string(from: Date())
        if settingsManager.secondsEnabled {
            updateSeconds()
        }
    }

    private func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        currentDate = formatter.string(from: Date())
    }

}

struct BackgroundView: View {
    let imageName: String

    var body: some View {
           Image(imageName)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .edgesIgnoringSafeArea(.all)
               .transition(.opacity)
       }
}

struct InfoView: View {
    @Binding var currentTime: String
    @Binding var currentDate: String
    @Binding var currentSeconds: String
    @Binding var weatherData: WeatherData
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        Group {
            VStack(alignment: .center) {
                ClockView(currentTime: $currentTime,
                          currentSeconds: $currentSeconds,
                          secondsEnabled: settingsManager.secondsEnabled)
                WeatherStatusView(currentDate: currentDate, weatherData: $weatherData)
            }
            .background(RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.43))
                    )
            .frame(width: 559, height: 350)
        }

    }
}

extension AnyTransition {
    static var flip: AnyTransition {
        let insertion = AnyTransition.opacity.combined(with: .scale)
        let removal = AnyTransition.opacity.combined(with: .scale)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
