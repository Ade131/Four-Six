//
//  Four_SixApp.swift
//  Four Six
//
//  Created by Aidan Kelly on 14/07/2023.
//

import SwiftUI

@main
struct Four_SixApp: App {
    
    //Create instance of CoffeeBrewingModel
    let coffeeModel = CoffeeBrewingModel()
    
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
