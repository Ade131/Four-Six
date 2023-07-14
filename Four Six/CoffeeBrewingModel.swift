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
    @Published var ratio: Double = 16.0
    
    //Property to track editing mode for coffee/water
    @Published var isEditingCoffee: Bool = false
    @Published var isEditingWater: Bool = false
    
    //Function to update coffee weight
    func updateWaterWeight(weight: Double) {
        waterWeight = weight
        updateCoffeeWeight()
    }
    
    func updateCoffeeWeight() {
        coffeeWeight = waterWeight / ratio
    }
    
    //Other settings
    @Published var audioEnabled: Bool = true
    
    //Function to toggle audio settings
    func toggleAudio() {
        audioEnabled.toggle()
    }
}
