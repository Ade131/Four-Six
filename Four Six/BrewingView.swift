//
//  BrewingView.swift
//  Four Six
//
//  Created by Aidan Kelly on 21/09/2023.
//

import SwiftUI

struct BrewingView: View {
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
    //Current pour number
    @State private var currentPourNumber = 1
    
    var body: some View {
        VStack {
            Text("Brewing Process")
                .font(.largeTitle)
                .padding()
            
            //Main timer
            Text("\(formatTime(coffeeModel.mainTimer))")
                .font(.headline)
            
            //Current Pour
            Text("\(formatTime(currentPourTime))")
                .font(.headline)
            
            //Pour weight instructions
            Text("\(coffeeModel.pourAmount)g")
                .font(.title)
            
            Text("\(coffeeModel.currentTotalWeight)g")
                .font(.title)
            
            //Stop button
            Button("Stop") {
                //Stop
            }
        }
    }
    
    //Func to convert time in seconds to minutes:seconds
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

#Preview {
    BrewingView()
}
