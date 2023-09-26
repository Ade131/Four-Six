//
//  UIElements.swift
//  Four Six
//
//  Created by Aidan Kelly on 22/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let backgroundColour = Color("Background")
    static let buttonColour = Color("Button")
    static let textColour = Color("Text")
    static let iconColour = Color("Icon")
    static let linkColour = Color("Link Text")
    static let listColour = Color("List Items")
    static let listSeparator = Color("List Separator")
    static let toggleColour = Color("Toggle")

    
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}


struct StartButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.buttonColour)
            .foregroundColor(Color.textColour)
            .cornerRadius(30)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct OptionsButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.buttonColour)
            .foregroundColor(Color.textColour)
            .cornerRadius(30)
            .scaleEffect(0.8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


struct CoffeeToggleStyle: ToggleStyle {
    var onColor = Color.toggleColour // Your desired "on" color
    var offColor = Color.gray // Your desired "off" color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            Rectangle()
                .frame(width: 50, height: 30)
                .foregroundColor(configuration.isOn ? onColor : offColor)
                .cornerRadius(15)
                .overlay(
                    Circle()
                        .foregroundColor(Color.white)
                        .padding(4)
                        .offset(x: configuration.isOn ? 12 : -12)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
 

