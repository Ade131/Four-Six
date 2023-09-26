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
    @Published var ratio: Int = 16
    
    //Properties for options
    @Published var taste: String = "Standard"
    @Published var strength: String = "Medium"
    
    //Array to hold pour logic
    @Published var pours: [Int] = []
    
    //Function to update coffee weight
    func updateWaterWeight(weight: Double) {
        waterWeight = weight
        updateCoffeeWeight()
    }
    
    func updateCoffeeWeight() {
        coffeeWeight = waterWeight / (Double(ratio))
    }
    
    //Func to calculate the brewing pours and sizes
    func calculatePours() {
        let firstStage = waterWeight * 0.4
        let secondStage = waterWeight * 0.6
        
        pours.removeAll() //Clear existing pours
        
        //Calculate first stage based on user prefernces
        var firstPour: Double = 0
        var secondPour: Double = 0
        switch taste {
        case "Standard":
            firstPour = (firstStage * 0.5).rounded()
            secondPour = firstStage - firstPour
        case "Sweeter":
            firstPour = (firstStage * 0.4).rounded()
            secondPour = firstStage - firstPour
        case "Brighter":
            firstPour = (firstStage * 0.6).rounded()
            secondPour = firstStage - firstPour
        default:
            //Handle unexpected case
            break
        }
        pours.append(Int(firstPour))
        pours.append(Int(secondPour))
        
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
        
        let remainingPourSize = Int((secondStage / Double(remainingPoursCount)).rounded())
        var remainingPourSum = 0
        for _ in 0..<remainingPoursCount {
            pours.append(remainingPourSize)
            remainingPourSum += remainingPourSize
        }
    }
    
    //Save settings for brewing preferences
    func saveBrewSettings() {
        UserDefaults.standard.set(self.taste, forKey: "Taste")
        UserDefaults.standard.set(self.strength, forKey: "Strength")
        UserDefaults.standard.set(self.ratio, forKey: "Ratio")
    }
    
    func loadSettings() {
            if let savedTaste = UserDefaults.standard.string(forKey: "Taste") {
                self.taste = savedTaste
            }
            if let savedStrength = UserDefaults.standard.string(forKey: "Strength") {
                self.strength = savedStrength
            }
            if let savedRatio = UserDefaults.standard.value(forKey: "Ratio") as? Int {
                self.ratio = savedRatio
            }
        }
    
    
    //Audio settings
    //Saved settings
    @Published var audioEnabled: Bool = UserDefaults.standard.bool(forKey: "sound") {
        didSet {
            UserDefaults.standard.set(audioEnabled, forKey: "sound")
        }
    }
    
    @Published var vibrateEnabled: Bool = UserDefaults.standard.bool(forKey: "vibrate") {
        didSet {
            UserDefaults.standard.set(vibrateEnabled, forKey: "vibrate")
        }
    }
    
    //Function to toggle audio settings
    func toggleAudio() {
        audioEnabled.toggle()
    }
    
}
