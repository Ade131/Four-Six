//
//  Four_SixApp.swift
//  Four Six
//
//  Created by Aidan Kelly on 14/07/2023.
//

import SwiftUI
import UIKit

enum AppearanceSetting: Int {
    case automatic = 0, light, dark
    
    var displayName: String {
            switch self {
            case .automatic:
                return "System"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            }
        }
}

@main
struct Four_SixApp: App {
    //Create instance of CoffeeBrewingModel
    let coffeeModel = CoffeeBrewingModel()
    
    //Initialise settings on app load
    init() {
        configureAppearance()
    }
    
    //Dark/Light mode settings stored in app storage
    @AppStorage("appearanceSelection") private var appearanceSelection: Int = AppearanceSetting.automatic.rawValue
    
    //Decide which colour scheme based on user selection
    var appearanceSwitch: ColorScheme? {
        switch AppearanceSetting(rawValue: appearanceSelection) {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return .none
        }
    }
    
    //Main scene body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coffeeModel)
                .preferredColorScheme(appearanceSwitch)
        }
    }
    
    //Apply appearance configurations
    private func configureAppearance() {
        configurePickerAppearance()
        configureNavigationBar()
    }

    //Changing segmented picker styles
    private func configurePickerAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.buttonColour)
        if let pickerTextColor = UIElements.pickerTextColour {
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: pickerTextColor], for: .selected)
        }
    }

    //Func for configuring the navigation bar appearance
    private func configureNavigationBar() {
        //Adjust navigation bar opacity
        if let uiBackgroundColor = UIColor(named: "Background") {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = uiBackgroundColor.withAlphaComponent(0.8)
            UINavigationBar.appearance().standardAppearance = appearance
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
