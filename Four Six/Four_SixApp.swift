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
    
    var body: some Scene {
        WindowGroup {
            //Pass coffeemodel to ContentView
            ContentView().environmentObject(coffeeModel)
        }
    }
}
