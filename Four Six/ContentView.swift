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
    var pickerOptions: [Int] {
        Array(stride(from: 100, to: 501, by: 10))
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                Text("4:6")
                    .font(.largeTitle)
                    .padding(.top)
                
                Spacer()
                
                Text("How much coffee are you brewing?")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 3) {
                    Text("\(waterInput) ml")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Edit")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showPicker = true
                        }
                        .actionSheet(isPresented: $showPicker) {
                            ActionSheet(title: Text("Select water amount (ml)"),
                                        buttons: pickerOptions.map { option in
                                    .default(Text("\(option)")) {
                                        waterInput = "\(option)"
                                    }
                            })
                        }
                }
                
                VStack(spacing: 3) {
                    Text("Prepare")
                        .font(.headline)
                    Text(" \(Int((Double(waterInput) ?? 250) / Double(coffeeModel.ratio)))g")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("of ground coffee")
                        .font(.headline)
                    
                    NavigationLink("", destination: BrewingView(), isActive: $navigateToBrew)
                        .hidden()
                }
                .padding(.top)
                
                Button("Brew Options") {
                    showOptions.toggle()
                }
                .sheet(isPresented: $showOptions) {
                    OptionsView()
                }
                .buttonStyle(BlueButton())
                .padding()
                
                Button("Start Brewing") {
                    if let waterWeight = Double(waterInput) {
                        coffeeModel.updateWaterWeight(weight: waterWeight)
                        coffeeModel.calculatePours()
                        navigateToBrew = true
                    }
                }
                .buttonStyle(BlueButton())
                
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CoffeeBrewingModel())
    }
}

