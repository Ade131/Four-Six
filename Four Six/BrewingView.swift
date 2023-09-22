//
//  BrewingView.swift
//  Four Six
//
//  Created by Aidan Kelly on 21/09/2023.
//

import SwiftUI

struct BrewingView: View {
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
    //Properties for brewing process
    @State private var totalPouredWeight = 0 //Weight poured
    @State private var currentPourNumber = 0 // Initialize to 0
    @State private var currentTime: Int = 0 // Total brewing time in seconds
    @State private var stageTime: Int = 0 // Time for each stage in seconds
    @State private var timer: Timer? // The timer
    @State private var totalTimeTimer: Timer? // Main total timer
    @State private var currentInstruction: String = "Get Ready"
    @State private var preTimerDone: Bool = false
    @State private var isDripping = false
    @State private var isBrewing = false
    @State private var isPaused = false
    
    var body: some View {
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
    
    private func startBrewing() {
        //5 seconds pre timer
        self.stageTime = 5
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentInstruction = "Get Ready"
            //Decrease time
            self.stageTime -= 1
            
            if self.stageTime < 0 {
                self.preTimerDone = true
                //reset time
                timer.invalidate()
                //Start the brewing
                startPours()
            }
        }
    }
    
    private func pauseBrewing() {
        timer?.invalidate()
        isPaused = true
    }
    
    private func resumeBrewing() {
        isPaused = false
        schedulePours()
    }
    
    private func startPours() {
        //reset variables
        self.currentPourNumber = 0
        self.totalPouredWeight = 0
        
        //Initialise the first pour
        let firstPourAmount = coffeeModel.pours[self.currentPourNumber]
        self.totalPouredWeight += firstPourAmount
        self.currentInstruction = "Pour \(firstPourAmount)g - (\(totalPouredWeight)g total)"
        self.stageTime = 10 // Set the first pour time to 10 seconds
        isDripping = true
        schedulePours()
    }
    
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
    
    private func moveToNextStage() {
        if self.currentPourNumber >= coffeeModel.pours.count {
            self.timer?.invalidate()
            self.currentInstruction = "Remove dripper when finished"
            return
        }
        
        if isDripping {
            self.currentInstruction = "Wait for next pour"
            self.currentPourNumber += 1
            self.stageTime = 35
        } else {
            let pourAmount = coffeeModel.pours[self.currentPourNumber]
            self.totalPouredWeight += pourAmount
            self.currentInstruction = "Pour \(pourAmount)g - (\(self.totalPouredWeight)g total)"
            self.stageTime = 10
        }
        
        // Skip the waiting time after the last pour
        if self.currentPourNumber >= coffeeModel.pours.count - 1 {
            self.stageTime = 0
        }
        
        isDripping.toggle()
    }
}


#Preview {
    BrewingView()
        .environmentObject(CoffeeBrewingModel())
}
