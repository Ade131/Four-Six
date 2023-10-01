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
    
    //On app load
    init() {
        configurePickerAppearance()
        //Adjust navigation bar opacity
        if let uiBackgroundColor = UIColor(named: "Background") {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = uiBackgroundColor.withAlphaComponent(0.8)
            UINavigationBar.appearance().standardAppearance = appearance
        }
    }
    //Dark/Light mode settings
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
    
    //Changing segmented picker styles
    private func configurePickerAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.buttonColour)
        if let pickerTextColor = UIElements.pickerTextColour {
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: pickerTextColor], for: .selected)
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

//Adding functionality for back swipe gesture:
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
