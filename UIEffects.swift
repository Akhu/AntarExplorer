//
//  UIEffects.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 28/06/2020.
//

import SwiftUI

struct UIEffects: View {
    var body: some View {
        Button("Hello") { }
            .buttonStyle(NeumorphicButtonStyle(bgColor: Color.blue))
    }
}

struct UIEffects_Previews: PreviewProvider {
    static var previews: some View {
        UIEffects()
    }
}
struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
                        .shadow(color: .black, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bgColor)
                }
        )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}
