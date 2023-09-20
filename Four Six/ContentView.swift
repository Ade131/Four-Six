//
//  ContentView.swift
//  Four Six
//
//  Created by Aidan Kelly on 14/07/2023.
//

import SwiftUI

struct ContentView: View {
    //Import model
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
    @State private var waterInput = "250" //Default 250ml
    @State private var showOptions = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("How much coffee are you brewing?")
                    .font(.headline)
                
                //User selects amount of water
                TextField("Enter Water Amount (ml)", text: $waterInput)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Display the coffee amount based on the user input
                if let waterWeight = Double(waterInput), !waterInput.isEmpty {
                    Text("Using a ratio of 1:\(Int(coffeeModel.ratio)), grind \(Int(waterWeight / coffeeModel.ratio))g of coffee")
                        .font(.subheadline)
                } else {
                    Text("Enter a valid numeric water amount to calculate coffee weight")
                        .font(.subheadline)
                        .foregroundColor(.red) // You can customize the color
                }
                
                
                Button("Start Brewing") {
                    if let waterWeight = Double(waterInput) {
                        coffeeModel.updateWaterWeight(weight: waterWeight)
                    }
                    
                }
                
                Button("Options") {
                    showOptions.toggle()
                }
                .sheet(isPresented: $showOptions) {
                    OptionsView()
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Spacer()
                    //Mute Audio Button
                    Image(systemName: coffeeModel.audioEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            //Toggle audio when tapped
                            coffeeModel.toggleAudio()
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
