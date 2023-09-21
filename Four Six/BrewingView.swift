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
    @State private var currentPourNumber = 0 // Initialize to 0
    @State private var currentTime: Int = 0 // Total brewing time in seconds
    @State private var stageTime: Int = 0 // Time for each stage in seconds
    @State private var timer: Timer? // The timer
    @State private var currentInstruction: String = "Get Ready"
    
    var body: some View {
        VStack {
            Text("Brewing Process")
                .font(.largeTitle)
                .padding()
            
            Text(formatTime(currentTime))
                .font(.title)
            
            Text(currentInstruction)
                .font(.headline)
            
            Text(formatTime(stageTime))
                .font(.title)
            
            //Stop button
            Button("Stop") {
                timer?.invalidate()
            }
        }
        .onAppear {
            startBrewing()
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
                //reset time
                self.stageTime = 0
                //Invalidate the timer and nujllify the timer to stop
                timer.invalidate()
                //Start the brewing
                startPours()
            }
            //Increase total time
            self.currentTime += 1
        }
    }
    
    private func startPours() {
        //reset current pour number
        self.currentPourNumber = 0
        
        //Schedule pours
        self.timer = Timer.scheduledTimer(withTimeInterval: 45, repeats: true) { timer in
            //When all pours are complete
            if self.currentPourNumber >= coffeeModel.pours.count {
                timer.invalidate()
                //TODO: indicate brewing is complete
            } else {
                //Start next pour
                self.stageTime = 10
                self.currentInstruction = "Pour"
                //TODO: Add logic here to perform the pour
                
                Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                    self.currentInstruction = "Wait for next pour"
                }
                //Move to the next pour
                self.currentPourNumber += 1
            }
            //Increase total time
            self.currentTime += 1
        }
    }
    
}

#Preview {
    BrewingView()
}
