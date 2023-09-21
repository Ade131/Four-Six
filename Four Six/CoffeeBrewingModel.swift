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
    
    //Properties for options
    @Published var taste: String = "Standard"
    @Published var strength: String = "Strong"
    
    //Array to hold pour logic
    @Published var pours: [Double] = []
    
    //Function to update coffee weight
    func updateWaterWeight(weight: Double) {
        waterWeight = weight
        updateCoffeeWeight()
    }
    
    func updateCoffeeWeight() {
        coffeeWeight = waterWeight / ratio
    }
    
    //Func to calculate the brewing pours and sizes
    func calculatePours() {
        let firstStage = waterWeight * 0.4
        let secondStage = waterWeight * 0.6
        
        pours.removeAll() //Clear existing pours
        
        //Calculate first stage based on user prefernces
        var firstPour: Double = 0.0
        var secondPour: Double = 0.0
        switch taste {
        case "Standard":
            firstPour = firstStage * 0.5
            secondPour = firstStage * 0.5
        case "Sweeter":
            firstPour = firstStage * 0.4
            secondPour = firstStage * 0.6
        case "Brighter":
            firstPour = firstStage * 0.6
            secondPour = firstStage * 0.4
        default:
            //Handle unexpected case
            break
        }
        pours.append(firstPour)
        pours.append(secondPour)
    
        //Calculate remaining pours based on strength
        var remainingPoursCount = 0
        switch strength {
        case "Strong":
            remainingPoursCount = 4
        case "Medium":
            remainingPoursCount = 3
        case "Light":
            remainingPoursCount = 2
        default:
            //Handle unexpected case
            break
        }
        
        let remainingPourSize = secondStage / Double(remainingPoursCount)
        for _ in 1...remainingPoursCount {
            pours.append(remainingPourSize)
        }
    }
    
    //Other settings
    @Published var audioEnabled: Bool = true
    
    //Function to toggle audio settings
    func toggleAudio() {
        audioEnabled.toggle()
    }
    
}
