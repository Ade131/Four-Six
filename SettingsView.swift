//
//  SettingsView.swift
//  Four Six
//
//  Created by Aidan Kelly on 22/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var coffeeModel: CoffeeBrewingModel // Add this line

    var body: some View {
            List {
                Section(header: Text("Settings")) {
                    Toggle("Mute Sounds", isOn: $coffeeModel.audioEnabled)
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: Text("Four Six Method")) {
                        Text("What is the Four Six Method?")
                    }
                    
                    NavigationLink(destination: Text("FAQ")) {
                        Text("FAQ")
                    }
                }
                
                Section(header: Text("Feedback")) {
                    NavigationLink(destination: Text("Rate on App Store")) {
                        Text("Rate in the App Store")
                    }
                    
                    NavigationLink(destination: Text("Acknowledgements")) {
                        Text("Acknowledgements")
                    }
                }
                
                Section(footer: Text("Version 1.0.0")) {
                }
            }
        }
    }

#Preview {
    SettingsView()
}
