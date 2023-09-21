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
    @State private var currentInstruction: String = "Get Ready"
    @State private var preTimerDone: Bool = false
    
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
            
            //Stop button
            Button("Stop") {
                timer?.invalidate()
            }
            .buttonStyle(BlueButton())
            .padding(.bottom, 20)
        }
        .onAppear {
            startBrewing()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
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
    
    private func startPours() {
        //reset variables
        self.currentPourNumber = 0
        self.totalPouredWeight = 0
        var isDripping = true //flag to show pour or not
        
        //Initialise the first pour
        let firstPourAmount = coffeeModel.pours[self.currentPourNumber]
        self.totalPouredWeight += firstPourAmount
        self.currentInstruction = "Pour \(firstPourAmount)g - (\(totalPouredWeight)g total)"
        self.stageTime = 10 // Set the first pour time to 10 seconds
        
        
        //Schedule pours
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.stageTime -= 1
            
            // If it's time to move to the next stage
            if self.stageTime <= 0 {
                if self.currentPourNumber >= coffeeModel.pours.count {
                    timer.invalidate()
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
                    self.currentInstruction = "Pour \(pourAmount)g - (\(totalPouredWeight)g total)"
                    self.stageTime = 10
                }
                
                //Skip the waiting time after the last pour
                if self.currentPourNumber == coffeeModel.pours.count - 1 {
                    self.stageTime = 0
                }
                
                isDripping.toggle()
            }
        }
    }
}


#Preview {
    BrewingView()
        .environmentObject(CoffeeBrewingModel())
}
