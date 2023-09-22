//
//  UIElements.swift
//  Four Six
//
//  Created by Aidan Kelly on 22/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let medPrimary = Color(hex: "5e503f")
    static let lightPrimary = Color(hex: "a9927d")
    static let backgroundColour = Color(hex: "22333b")
    static let lightSecondary = Color(hex: "B7B7A4")
    static let medSecondary = Color(hex: "A5A58D")
    static let darkSecondary = Color(hex: "6B705C")
    
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
            .background(Color.lightPrimary)
            .foregroundColor(.white)
            .cornerRadius(30)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct OptionsButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.lightPrimary)
            .foregroundColor(.white)
            .cornerRadius(30)
            .scaleEffect(0.8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

