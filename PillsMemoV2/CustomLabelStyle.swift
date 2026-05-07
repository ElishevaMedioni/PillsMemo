
//
//  CustomLabelStyle.swift
//  PillsMemo
//
//  Created by Elisheva Medioni on 10/03/2024.
//


import SwiftUI

struct CustomLabelStyle: LabelStyle {
    @ScaledMetric private var iconWidth: Double = 40
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.icon
                .imageScale(.large)
                .frame(width: iconWidth)
            configuration.title
        }
    }
}
