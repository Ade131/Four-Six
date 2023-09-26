//
//  OptionsView.swift
//  Four Six
//
//  Created by Aidan Kelly on 20/09/2023.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel
    
    var body: some View {
        ZStack {
            Color.backgroundColour.ignoresSafeArea()
            VStack {
                Text("Options")
                    .font(.title)
                    .padding()
                
                //Taste selection
                Text("Balance")
                    .font(.headline)
                Picker("Taste", selection: $coffeeModel.taste) {
                    Text("Sweeter").tag("Sweeter")
                    Text("Standard").tag("Standard")
                    Text("Brighter").tag("Brighter")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Strength selection
                Text("Strength")
                    .font(.headline)
                Picker("Strength", selection: $coffeeModel.strength) {
                    Text("Light").tag("Light")
                    Text("Medium").tag("Medium")
                    Text("Strong").tag("Strong")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                //Ratio Selection
                Text("Ratio")
                    .font(.headline)
                Picker("Ratio", selection: $coffeeModel.ratio) {
                    Text("1:15").tag(15)
                    Text("1:16").tag(16)
                    Text("1:17").tag(17)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
            }
        }
        
        .onDisappear {
            //apply options
            coffeeModel.calculatePours()
        }
    }
}

#Preview {
    OptionsView()
        .environmentObject(CoffeeBrewingModel()) 
}
