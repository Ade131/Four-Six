//
//  Four_SixApp.swift
//  Four Six
//
//  Created by Aidan Kelly on 14/07/2023.
//

import SwiftUI
import UIKit

@main
struct Four_SixApp: App {
    
    //Create instance of CoffeeBrewingModel
    let coffeeModel = CoffeeBrewingModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.buttonColour)
        if let pickerTextColor = UIElements.pickerTextColour {
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: pickerTextColor], for: .selected)
        }
    }
    
    //AppStorage settings
    @AppStorage("appearanceSelection") private var appearanceSelection: Int = 0 //Dark/Light Preference
    
    //Appearance settings
    var appearanceSwitch: ColorScheme? {
            if appearanceSelection == 1 {
                return .light
            }
            else if appearanceSelection == 2 {
                return .dark
            }
            else {
                return .none
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //Pass coffeeModel
                .environmentObject(coffeeModel)
            //Appearance Preference
                .preferredColorScheme(appearanceSwitch)
        }
    }
}
