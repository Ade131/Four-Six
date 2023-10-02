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
    
    //Variables
    @State private var waterInput = "250"           //Default water amount
    @State private var pickerHeight: CGFloat = 0    //Height of water input when shown
    @State private var optionsHeight: CGFloat = 0   //Height of brew options when shown
    @State private var navigateToBrew = false       //Navigate to brewing page
    @Environment(\.colorScheme) var colorScheme     //To adjust logo

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColour.ignoresSafeArea()
                
                VStack(spacing: 10) {
                    Spacer()
                    LogoView(colorScheme: colorScheme)
                    Spacer()
                    BrewAmountView(waterInput: $waterInput, pickerHeight: $pickerHeight)

                    CoffeePrepareView(waterInput: $waterInput, coffeeModel: coffeeModel)
                        .padding(.top, 15)
                    
                    OptionsToggleView(optionsHeight: $optionsHeight)
                    
                    OptionsMenu()
                        .environmentObject(coffeeModel)
                        .frame(height: optionsHeight)
                        .clipped()
                        .opacity(optionsHeight > 0 ? 1 : 0)
                        .padding(.leading, optionsHeight > 0 ? 15 : 0)
                        .padding(.trailing, optionsHeight > 0 ? 15 : 0)
                        .padding(.bottom, optionsHeight > 0 ? 15 : 0)
                    
                    StartBrewButton(waterInput: $waterInput, navigateToBrew: $navigateToBrew, coffeeModel: coffeeModel)
                    Spacer()
                }
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

//Subview to show the app logo
struct LogoView: View {
    var colorScheme: ColorScheme
    
    var body: some View {
        if colorScheme == .dark {
            Image("logoDark")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
        } else {
            Image("logoLight")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
        }
    }
}

//Subview to show the amount being brewed
struct BrewAmountView: View {
    @Binding var waterInput: String
    @Binding var pickerHeight: CGFloat
    //Options for water amount selector
    var pickerOptions: [Int] {
        Array(stride(from: 200, to: 601, by: 10))
    }

    var body: some View {
        
        Text("How much coffee are you brewing?")
                               .font(.headline)
                               .padding(.top)
        
        VStack(spacing: 3) {
            Text("\(waterInput) ml")
                .font(.title)
                .fontWeight(.bold)
            ZStack {
                if pickerHeight == 0 {
                    Button("Edit") {
                        withAnimation {
                            pickerHeight = 150
                        }
                        
                    }
                    .foregroundColor(Color.linkColour)
                    .opacity(pickerHeight == 0 ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: pickerHeight)
                } else {
                    Button("Done") {
                        withAnimation {
                            pickerHeight = 0
                        }
                    }
                    .foregroundColor(Color.linkColour)
                    .opacity(pickerHeight > 0 ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: pickerHeight)
                }
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
    }
}

//Subview to show amount of coffee to prepare
struct CoffeePrepareView: View {
    @Binding var waterInput: String
    @ObservedObject var coffeeModel: CoffeeBrewingModel
    
    var body: some View {
        VStack(spacing: 3) {
            Text("Prepare")
                .font(.headline)
            Text(" \(Int((Double(waterInput) ?? 250) / Double(coffeeModel.ratio)))g")
                .font(.title)
                .fontWeight(.bold)
            Text("of ground coffee")
                .font(.headline)
        }
    }
}

//Subview to show the brew options toggle
struct OptionsToggleView: View {
    @Binding var optionsHeight: CGFloat
    
    var body: some View {
        Button(action: {
            withAnimation {
                optionsHeight = optionsHeight > 0 ? 0 : 150
            }
        }) {
            if optionsHeight > 0 {
                Text("Close")
                    .padding(.top, 10)
            } else {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 30))
                    .padding(20)
            }
        }
        .foregroundColor(Color.linkColour)
    }
}

//Subview to handle the start brewing button
struct StartBrewButton: View {
    @Binding var waterInput: String
    @Binding var navigateToBrew: Bool
    @ObservedObject var coffeeModel: CoffeeBrewingModel
    
    var body: some View {
        Button(action: {
            startBrew()
        }) {
            Text("Start Brewing")
        }
        .buttonStyle(StartButton())
        .fullScreenCover(isPresented: $navigateToBrew, content: { BrewingView() })
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

//Subview to show the brewing option pickers
struct OptionsMenu: View {
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
    var body: some View {
        VStack {
            //Taste selection
            Text("Balance")
                .font(.headline)
            Picker("Taste", selection: $coffeeModel.taste) {
                Text("Sweeter").tag("Sweeter")
                Text("Standard").tag("Standard")
                Text("Brighter").tag("Brighter")
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: coffeeModel.taste) { newValue in
                coffeeModel.calculatePours()
                coffeeModel.saveBrewSettings()
            }
            
            // Strength selection
            Text("Strength")
                .font(.headline)
                .padding(.top, 15)
            Picker("Strength", selection: $coffeeModel.strength) {
                Text("Light").tag("Light")
                Text("Medium").tag("Medium")
                Text("Strong").tag("Strong")
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: coffeeModel.strength) { newValue in
                coffeeModel.calculatePours()
                coffeeModel.saveBrewSettings()
            }
        }
        .onAppear {
            coffeeModel.loadSettings()
        }
        .onDisappear {
            coffeeModel.saveBrewSettings()
            coffeeModel.calculatePours()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CoffeeBrewingModel())
    }
}

