//
//  BrewingView.swift
//  Four Six
//
//  Created by Aidan Kelly on 21/09/2023.
//

import SwiftUI

//Constants for readability
let preTimerSeconds = 5
let pourTimeSeconds = 10
let waitTimeSeconds = 25

struct BrewingView: View {
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
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
    
    var body: some View {
        //UI
        ZStack {
            Color.backgroundColour.ignoresSafeArea()
            VStack {
                Text("Brewing Process")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                Text(formatTime(currentTime))
                    .font(.title)
                
                Spacer()
                
                Text(formatTime(stageTime))
                    .font(.system(size: 36))
                    .padding(.bottom, 20)
                
                Text(currentInstruction)
                    .font(.system(size: 24))
                
                Spacer()
                
                ZStack {
                    //Pause / Skip buttons
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
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.moveToNextStage()
                        }) {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.totalTimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.preTimerDone {
                    self.currentTime += 1
                }
            }
        }
    }
    
    //Func to convert time in seconds to minutes:seconds
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //Begin the brewing logic
    private func startBrewing() {
        //5 seconds pre timer
        self.stageTime = preTimerSeconds
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentInstruction = "Get Ready"
            //Decrease time
            self.stageTime -= 1
            
            //Move to pours once pretimer complete
            if self.stageTime < 0 {
                self.preTimerDone = true
                //reset time
                timer.invalidate()
                //Start the brewing
                startPours()
            }
        }
    }
    
    //Brewing begins, pours set up
    private func startPours() {
        //reset variables
        self.currentPourNumber = 0
        self.totalPouredWeight = 0
        
        //Initialise the first pour
        let firstPourAmount = coffeeModel.pours[self.currentPourNumber]
        self.totalPouredWeight += firstPourAmount
        self.currentInstruction = "Pour \(firstPourAmount)g - (\(totalPouredWeight)g total)"
        self.stageTime = pourTimeSeconds // Set the first pour time to 10 seconds
        isDripping = true
        schedulePours()
    }
    
    //Timer logic for pours
    private func schedulePours() {
        
        totalTimeTimer?.invalidate()
        totalTimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            if self.preTimerDone {
                self.currentTime += 1
            }
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.stageTime -= 1
            
            if self.stageTime <= 0 {
                self.moveToNextStage()
            }
        }
    }
    
    //Next stage once timer is complete / skip button pressed
    private func moveToNextStage() {
        if self.currentPourNumber >= coffeeModel.pours.count {
            self.timer?.invalidate()
            self.currentInstruction = "Remove dripper when finished"
            return
        }
        
        if isDripping {
            self.currentInstruction = "Wait for next pour"
            self.currentPourNumber += 1
            self.stageTime = waitTimeSeconds
        } else {
            let pourAmount = coffeeModel.pours[self.currentPourNumber]
            self.totalPouredWeight += pourAmount
            self.currentInstruction = "Pour \(pourAmount)g - (\(self.totalPouredWeight)g total)"
            self.stageTime = pourTimeSeconds
        }
        
        // Skip the waiting time after the last pour
        if self.currentPourNumber >= coffeeModel.pours.count - 1 {
            self.stageTime = 0
        }
        
        isDripping.toggle()
    }
    
    //Logic for pause/resume while brewing
    private func pauseBrewing() {
        timer?.invalidate()
        isPaused = true
    }
    
    private func resumeBrewing() {
        isPaused = false
        schedulePours()
    }
}


// For preview
struct BrewingView_Previews: PreviewProvider {
    static var previews: some View {
        BrewingView().environmentObject(CoffeeBrewingModel())
    }
}
