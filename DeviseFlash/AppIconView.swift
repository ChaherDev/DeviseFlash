//
//  AppIconView.swift
//  DeviseFlash
//
//  Created by Chaher Machhour on 31/10/2024.
//

import SwiftUI

struct AppIconView: View {
    let gradientColors = [Color(red: 0.1, green: 0.6, blue: 0.6), Color(red: 0.1, green: 0.9, blue: 0.9)]
    let iconColor = Color(red: 1.0, green: 0.8, blue: 0.0)

    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: gradientColors), center: .center, startRadius: 0, endRadius: 350)
                .frame(width: 350, height: 350)

            VStack(spacing: 17.5) {
                HStack(spacing: -10) {
                    Text("€")
                        .font(.system(size: 100))
                        .foregroundColor(iconColor)

                    Text("⚡️")
                        .font(.system(size: 150))

                    Text("$")
                        .font(.system(size: 100))
                        .foregroundColor(iconColor)
                        .offset(x: -9)
                }
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)

                Text("DeviseFlash")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(iconColor)
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    AppIconView()
}
