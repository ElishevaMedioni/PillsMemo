//
//  DoseRowView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 30/03/2025.
//

import SwiftUI

struct DoseRowView: View {
    
    let dose: Dose
    @Bindable var drug: Drug
    let hapticFeedback: UIImpactFeedbackGenerator
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dose.time, style: .date)
                Text(dose.time, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                if let index = drug.doses.firstIndex(where: { $0.id == dose.id }) {
                    hapticFeedback.impactOccurred()
                    drug.doses[index].timeTaken = drug.doses[index].timeTaken == nil ? Date.now : nil
                }
            }) {
                Image(systemName: (dose.timeTaken != nil) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor((dose.timeTaken != nil) ? .green : .gray)
                    .font(.title)
            }
            .buttonStyle(.plain)
        }
        .frame(height: 50)
    }
}
