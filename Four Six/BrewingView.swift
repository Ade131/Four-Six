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
let preTimerSeconds = 3
let pourTimeSeconds = 10
let waitTimeSeconds = 35

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
    @State private var preTimerDone: Bool = false // pretimer flag
    @State private var isDripping = false // drawdown flag
    @State private var isBrewing = false // brew active flag
    @State private var isPaused = false // pause timer flag
    @State private var isComplete = false //brewing complete flag
    @State private var currentStep: Int = 0 // Current step
    //Animation Variables
    @State private var stageProgress: Double = 1.0 // Smooth timer progress
    @State private var shouldAnimateProgress: Bool = false //Don't animate between steps
    
    //Calculate total pours for brewing progress
    var totalSteps: Int {
        return ((coffeeModel.pours.count * 2) - 1)
    }
    
    var body: some View {
        //UI
        ZStack {
            Color.backgroundColour.ignoresSafeArea()
            VStack {
                Text("Stage \(currentStep) of \(totalSteps + 1)")
                    .font(.title)
                    .padding(.top, 20)
                    .monospacedDigit()
                
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
                            .font(.system(size: 20))
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
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(StartButton())
                    }
                }
                .frame(height: 100)
            }
        }
        .onAppear {
            self.totalTimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.preTimerDone {
                    self.currentTime += 1
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
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
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
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
                self.currentInstruction = "Wait for next pour"
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


// For preview
struct BrewingView_Previews: PreviewProvider {
    static var previews: some View {
        BrewingView().environmentObject(CoffeeBrewingModel())
    }
}
