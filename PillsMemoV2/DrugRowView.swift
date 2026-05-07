//
//  DrugRowView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 03/03/2025.
//


import SwiftUI

struct DrugRowView: View {
    
    @ScaledMetric var imageWidth: CGFloat = 40
    @State var drug: Drug
    
    var body: some View {
        HStack {
            Label {
                VStack(alignment: .leading, spacing: 5) {
                    Text(drug.title)
                        .fontWeight(.bold)
                        .font(.headline)
                    
                    // drug.doses is unordered (SwiftData to-many), so sort before picking "next".
                    if let nextDoseTime = drug.doses
                        .filter({ $0.timeTaken == nil && $0.time > Date() })
                        .min(by: { $0.time < $1.time })?.time {
                        Text("Next dose: " + nextDoseTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("All doses completed")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            } icon: {
                Image(systemName: drug.symbol)
                    .font(.title2)
                    .foregroundStyle(Color(drug.color))
                    .padding(.trailing, 15)
            }
            .labelStyle(CustomLabelStyle())
        }
    }
}

//struct DrugRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DrugRowView(drug: Drug.example) // Create a binding with .constant
//    }
//}
