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
    @State private var navigateToBrew = false
    @State private var showPicker = false
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("4:6")
                    .font(.largeTitle)
                    .padding(.top)
                
                Spacer()
                
                Text("How much coffee are you brewing?")
                    .font(.headline)
                    .padding(.top)
                
                Text("\(waterInput) ml")
                    .font(.title)
                
                Text("Edit")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        showPicker.toggle()
                    }
                    .sheet(isPresented: $showPicker) {
                        VStack {
                            Text("Select water amount (ml)")
                            Picker("", selection: $waterInput) {
                                ForEach(Array(stride(from: 100, to: 501, by: 10)), id: \.self) { i in
                                    Text("\(i)")
                                }
                                .pickerStyle(WheelPickerStyle())
                            }
                            
                        }
                        
                        Text("Prepare \(Int((Double(waterInput) ?? 250) / Double(coffeeModel.ratio)))g of coffee")
                        
                        // Display the coffee amount based on the user input
                        if let waterWeight = Double(waterInput), !waterInput.isEmpty {
                            Text("Using a ratio of 1:\(coffeeModel.ratio), grind \(Int(waterWeight / (Double(coffeeModel.ratio))))g of coffee")
                                .font(.headline)
                        } else {
                            Text("Enter a valid numeric water amount to calculate coffee weight")
                                .font(.subheadline)
                                .foregroundColor(.red) // You can customize the color
                        }
                        
                        NavigationLink("", destination: BrewingView(), isActive: $navigateToBrew)
                            .hidden()
                        
                        Button("Start Brewing") {
                            if let waterWeight = Double(waterInput) {
                                coffeeModel.updateWaterWeight(weight: waterWeight)
                                coffeeModel.calculatePours()
                                navigateToBrew = true
                            }
                        }
                        .buttonStyle(BlueButton())
                        
                        Button("Options") {
                            showOptions.toggle()
                        }
                        .sheet(isPresented: $showOptions) {
                            OptionsView()
                        }
                        .buttonStyle(BlueButton())
                        .padding()
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            //Mute Audio Button
                            Image(systemName: coffeeModel.audioEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .onTapGesture {
                                    //Toggle audio when tapped
                                    coffeeModel.toggleAudio()
                                }
                        }
                    }
            }
        }
    }
    
    struct BlueButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(CoffeeBrewingModel())
        }
    }
}
