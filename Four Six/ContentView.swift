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
    @State private var pickerHeight: CGFloat = 0
    @State private var selectedPickerIndex = 0
    @State private var editing = false
    var pickerOptions: [Int] {
        Array(stride(from: 200, to: 601, by: 10))
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour.ignoresSafeArea()
                VStack(spacing: 10) {
                    
                    Text("4:6")
                        .font(.largeTitle)
                        .padding(.top, -40)
                    
                    Spacer()
                    
                    Text("How much coffee are you brewing?")
                        .font(.headline)
                        .padding(.top)
                    
                    
                    VStack(spacing: 3) {
                        Text("\(waterInput) ml")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if pickerHeight == 0 {
                            Button("Edit") {
                                withAnimation {
                                    pickerHeight = 150
                                }
                                
                            }
                            .foregroundColor(Color.linkColour)
                        } else {
                            Button("Done") {
                                withAnimation {
                                    pickerHeight = 0
                                }
                            }
                            .foregroundColor(Color.linkColour)
                        }
                        
                        Picker("Select water amount (ml)", selection: $waterInput) {
                            ForEach(pickerOptions, id: \.self) { option in
                                Text("\(option)").tag("\(option)")
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: pickerHeight)
                        .clipped()
                    }
                    
                    VStack(spacing: 3) {
                        Text("Prepare")
                            .font(.headline)
                        Text(" \(Int((Double(waterInput) ?? 250) / Double(coffeeModel.ratio)))g")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("of ground coffee")
                            .font(.headline)
                        
                    }
                    .padding(.top)
                    
                    Button("Options") {
                        showOptions.toggle()
                    }
                    .sheet(isPresented: $showOptions) {
                        OptionsView()
                    }
                    .buttonStyle(OptionsButton())
                    .padding()
                    
                    Button(action: {
                        startBrew()
                    }) {
                        Text("Start Brewing")
                    }
                    .buttonStyle(StartButton())
                    .navigationDestination(isPresented: $navigateToBrew, destination: { BrewingView() })
                    
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView().environmentObject(coffeeModel)) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color.iconColour)
                        }
                    }
                }
            }
        }
    }
    
    //Logic when pressing start button
    func startBrew() {
        if let waterWeight = Double(waterInput) {
            coffeeModel.updateWaterWeight(weight: waterWeight)
            coffeeModel.calculatePours()
        }
        self.navigateToBrew = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CoffeeBrewingModel())
    }
}

