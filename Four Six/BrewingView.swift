//
//  BrewingView.swift
//  Four Six
//
//  Created by Aidan Kelly on 21/09/2023.
//

import SwiftUI
import AVFoundation
import AudioToolbox

//Constants for readability
let preTimerSeconds = 5
let pourTimeSeconds = 12
let waitTimeSeconds = 33

//Sounds
private var countdownAudioPlayer: AVAudioPlayer?
private var finishAudioPlayer: AVAudioPlayer?

struct BrewingView: View {
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // For navigation
    
    //Properties for brewing process
    @State private var totalPouredWeight = 0 //Weight poured
    @State private var currentPourNumber = 0 // Initialize to 0
    @State private var currentTime: Int = 0 // Total brewing time in seconds
    @State private var stageTime = preTimerSeconds
    @State private var timer: Timer? // The timer
    @State private var totalTimeTimer: Timer? // Main total timer
    @State private var currentInstruction = "Get Ready" // Current instruction text
    @State private var currentStep: Int = 0 // Current step
    //Flags
    @State private var preTimerDone = false // pretimer flag
    @State private var isDripping = false // drawdown flag
    @State private var isBrewing = false // brew active flag
    @State private var isPaused = false // pause timer flag
    @State private var isComplete = false //brewing complete flag
    @State private var isViewActive = false // Is view open flag
    @State private var showingCancelAlert = false //Cancel button
    //Animation Variables
    @State private var stageProgress: Double = 1.0 // Smooth timer progress
    @State private var shouldAnimateProgress: Bool = false //Don't animate between steps
    // total pours for brewing progress
    var totalSteps: Int {
        return ((coffeeModel.pours.count * 2) - 1)
    }
    
    
    var body: some View {
        //UI
        ZStack {
            Color.backgroundColour.ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        showingCancelAlert = true
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }
                        .foregroundColor(Color.linkColour)
                        .padding(.leading, 15)
                    }
                    .alert(isPresented: $showingCancelAlert) {
                        Alert(
                            title: Text("Cancel the Brew?"),
                            primaryButton: .destructive(Text("Yes")) {
                                stopBrewing()
                                presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel(Text("No"))
                            )
                    }
                    Spacer()
                    
                    Text("\(currentStep) of \(totalSteps + 1)")
                        .font(.system(size: 20))
                        .padding(6)
                        .monospacedDigit()
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "xmark").opacity(0)
                        Text("Cancel").opacity(0)
                    }
                    .padding(.trailing, 15)
                }
                
                Text("Total Time")
                    .font(.footnote)
                
                Text(formatTime(currentTime))
                    .font(.title)
                    .monospacedDigit()
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.listSeparator, lineWidth: 10)
                        .frame(width: 270, height: 270)
                        .overlay(
                            CountdownCircleShape(progress: shouldAnimateProgress ? stageProgress : 1)
                                .stroke(Color.buttonColour, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .animation(.linear(duration: 1), value: stageTime)
                        )
                    
                    VStack(alignment: .center) {
                        
                        Text(currentInstruction)
                            .font(.system(size: 30))
                            .multilineTextAlignment(.center)
                        
                        Text(formatTime(stageTime))
                            .font(.system(size: 36))
                            .monospacedDigit()
                    }
                }
                .frame(height: 300)
                .padding()
                
                
                Text("\(totalPouredWeight)g total")
                    .font(.system(size: 20))
                
                Spacer()
                
                //Pause / Skip / Done buttons
                ZStack {
                    //Show pause/skip button if running
                    if !isComplete {
                        HStack {
                            Spacer()
                            Button(action: {
                                if isPaused {
                                    resumeBrewing()
                                } else if isBrewing {
                                    pauseBrewing()
                                } else {
                                    startBrewing()
                                }
                                isBrewing.toggle()
                            }) {
                                Image(systemName: isBrewing ? "pause.fill" : "play.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.buttonColour)
                            }
                            
                            Spacer()
                        }
                        //Show 'skip' button if not at last stage
                        if preTimerDone && currentPourNumber < (coffeeModel.pours.count) {
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    self.moveToNextStage()
                                }) {
                                    Image(systemName: "forward.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color.buttonColour)                                .padding(.trailing, 20)
                                }
                            }
                        }
                        //show 'done' button if complete
                    } else {
                        Button(" Done ") {
                            stopBrewing()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(StartButton())
                    }
                }
                .frame(height: 100)
            }
        }
        .onAppear {
            //Initialize Timer
            self.totalTimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.preTimerDone {
                    self.currentTime += 1
                }
            }
            //Prepare audio files
            prepareAudio()
        }
    }
    
    private func startBrewing() {
        self.preTimerDone = false
        self.currentStep = 0
        self.totalPouredWeight = 0
        self.currentPourNumber = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                shouldAnimateProgress = true
            }
        }
        
        scheduleUniversalTimer()
    }
    
    private func scheduleUniversalTimer() {
        self.timer?.invalidate()
        self.totalTimeTimer?.invalidate()
        
        totalTimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.preTimerDone {
                self.currentTime += 1
            }
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.stageTime -= 1
            self.stageProgress = Double(self.stageTime) / Double(currentMaxTime())
            
            //Play audio
            if (self.stageTime == 2 || self.stageTime == 1) && coffeeModel.audioEnabled {
                countdownAudioPlayer?.currentTime = 0
                countdownAudioPlayer?.play()
            }
            
            if self.stageTime == 0 && coffeeModel.audioEnabled {
                finishAudioPlayer?.play()
            }
            
            if self.stageTime < 0 {
                moveToNextStage()
            }
        }
    }
    
    private func moveToNextStage() {
        withAnimation(.none) {
            shouldAnimateProgress = false
            stageProgress = 1.0
        }
        
        //Vibrate on stage transition if enabled
        if coffeeModel.vibrateEnabled && !isComplete {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        // Move to the next step if not complete
        if !isComplete {
            self.currentStep += 1
        }
        
        if self.currentStep == 1 {
            self.preTimerDone = true
            let pourAmount = coffeeModel.pours[self.currentPourNumber]
            self.totalPouredWeight += pourAmount
            self.currentInstruction = "Pour \(pourAmount)g"
            self.stageTime = pourTimeSeconds
            self.currentPourNumber += 1
            isDripping.toggle()
        } else if self.currentPourNumber >= coffeeModel.pours.count {
            self.currentInstruction = "Remove dripper\nwhen finished"
            isComplete = true
            self.stageTime = 0
            return
        } else {
            if isDripping {
                self.currentInstruction = "Let it drip"
                self.stageTime = waitTimeSeconds
            } else {
                let pourAmount = coffeeModel.pours[self.currentPourNumber]
                self.totalPouredWeight += pourAmount
                self.currentInstruction = "Pour \(pourAmount)g"
                self.stageTime = pourTimeSeconds
                self.currentPourNumber += 1
            }
            isDripping.toggle()
        }
        
        self.stageProgress = Double(self.stageTime) / Double(currentMaxTime())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                shouldAnimateProgress = true
            }
        }
    }
    
    
    //Logic for pause/resume while brewing
    private func pauseBrewing() {
        timer?.invalidate()
        isPaused = true
    }
    
    private func resumeBrewing() {
        isPaused = false
        scheduleUniversalTimer()
    }
    
    //Function to get the current stage time for the timer
    private func currentMaxTime() -> Double {
        if !preTimerDone {
            return Double(preTimerSeconds)
        }
        return isDripping ? Double(pourTimeSeconds) : Double(waitTimeSeconds)
    }
    
    //Stop brewing
    private func stopBrewing() {
        timer?.invalidate() // Invalidate the stage timer
        totalTimeTimer?.invalidate() // Invalidate the total time timer
        countdownAudioPlayer?.stop() // Stop any playing countdown audio
        finishAudioPlayer?.stop() // Stop any playing finish audio
    }
    
}

//Func to convert time in seconds to minutes:seconds
private func formatTime(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let seconds = seconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

//Countdown circle shape definition
struct CountdownCircleShape: Shape, Animatable {
    var progress: CGFloat
    
    var animatableData: Double {
        get {progress}
        set {progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: -90 + 360 * Double(progress)),
                    clockwise: false)
        return path
    }
}

//Prepare the audio files
private func prepareAudio() {
    do {
        if let countdownPath = Bundle.main.path(forResource: "countdown", ofType: "mp3"),
           let finishPath = Bundle.main.path(forResource: "finish", ofType: "mp3") {
            countdownAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: countdownPath))
            finishAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: finishPath))
        }
    } catch {
        print("Couldn't load audio files")
    }
}

// For preview
struct BrewingView_Previews: PreviewProvider {
    static var previews: some View {
        BrewingView().environmentObject(CoffeeBrewingModel())
    }
}
