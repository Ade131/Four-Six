//
//  UIElements.swift
//  Four Six
//
//  Created by Aidan Kelly on 22/09/2023.
//

import Foundation
import SwiftUI

struct StartButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.blue)
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
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(30)
            .scaleEffect(0.8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

