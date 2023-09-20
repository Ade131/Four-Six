//
//  CoffeeBrewingModel.swift
//  Four Six
//
//  Created by Aidan Kelly on 20/09/2023.
//

import Foundation
import SwiftUI

class CoffeeBrewingModel: ObservableObject {
    //Define properties to store water weight and the desired ratio
    @Published var waterWeight: Double = 0.0
    @Published var coffeeWeight: Double = 0.0
    @Published var ratio: Double = 15.0
    
    //Function to update coffee weight
    func updateWaterWeight(weight: Double) {
        waterWeight = weight
        updateCoffeeWeight()
    }
    
    func updateCoffeeWeight() {
        coffeeWeight = waterWeight / ratio
    }
    
    //Properties for options
    @Published var taste: String = "Standard"
    @Published var strength: String = "Strong"
    
    //Function to apply taste and strength preferences
    func applyOptions() {
        //stub
    }
    
    //Other settings
    @Published var audioEnabled: Bool = true
    
    //Function to toggle audio settings
    func toggleAudio() {
        audioEnabled.toggle()
    }
}
