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
    
    //Functions to update coffee weight
    func updateWaterWeight(weight: Double) {
        waterWeight = weight
        updateCoffeeWeight()
    }
    func updateCoffeeWeight() {
        coffeeWeight = waterWeight / (Double(ratio))
    }
    
    //Func to calculate the brewing pours and sizes
    func calculatePours() {
        pours.removeAll() //Clear existing pours
        calculateFirstStagePours()
        calculateSecondStagePours()
    }
    
    //Calculate first pours
    func calculateFirstStagePours() {
        let firstStage = waterWeight * 0.4
                var firstPour: Double = 0.0
                var secondPour: Double = 0.0
                
                switch taste {
                case "Standard":
                    firstPour = (firstStage * 0.5).rounded()
                case "Sweeter":
                    firstPour = (firstStage * 0.4).rounded()
                case "Brighter":
                    firstPour = (firstStage * 0.6).rounded()
                default:
                    break
                }
                secondPour = firstStage - firstPour
                pours.append(contentsOf: [Int(firstPour), Int(secondPour)])
    }
    
    //Calculate second pours
    func calculateSecondStagePours() {
        let secondStage = waterWeight * 0.6
               var remainingPoursCount: Int = 0
               
               switch strength {
               case "Strong":
                   remainingPoursCount = 4
               case "Medium":
                   remainingPoursCount = 3
               case "Light":
                   remainingPoursCount = 2
               default:
                   break
               }
               
               let remainingPourSize = Int((secondStage / Double(remainingPoursCount)).rounded())
               pours.append(contentsOf: Array(repeating: remainingPourSize, count: remainingPoursCount))
    }
    
    //Save settings for brewing preferences
    func saveBrewSettings() {
        UserDefaults.standard.set(self.taste, forKey: "Taste")
        UserDefaults.standard.set(self.strength, forKey: "Strength")
    }
    
    //Load saved settings for brewing preferences
    func loadSettings() {
            if let savedTaste = UserDefaults.standard.string(forKey: "Taste") {
                self.taste = savedTaste
            }
            if let savedStrength = UserDefaults.standard.string(forKey: "Strength") {
                self.strength = savedStrength
            }
        }
    
    //Saved settings for vibration and audio
    @Published var audioEnabled: Bool = {
        if UserDefaults.standard.object(forKey: "sound") == nil {
            return true // Default value
        } else {
            return UserDefaults.standard.bool(forKey: "sound")
        }
    }() {
        didSet {
            UserDefaults.standard.set(audioEnabled, forKey: "sound")
        }
    }

    @Published var vibrateEnabled: Bool = {
        if UserDefaults.standard.object(forKey: "vibrate") == nil {
            return true // Default value
        } else {
            return UserDefaults.standard.bool(forKey: "vibrate")
        }
    }() {
        didSet {
            UserDefaults.standard.set(vibrateEnabled, forKey: "vibrate")
        }
    }
    
    //Function to toggle audio settings
    func toggleAudio() {
        audioEnabled.toggle()
    }
    
}
