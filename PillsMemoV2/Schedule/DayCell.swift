//
//  DayCell.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 30/03/2025.
//

import SwiftUI

struct DayCell: View {
    
    let date: Date
    let drug: Drug
    
    var body: some View {
        VStack {
            Text(dayOfWeekSymbol(for: date))
                .font(.caption)
            Text("\(dayOfMonth(for: date))")
                .font(.headline)
            
            // Dose indicator: green = all taken, orange = some taken, red = none taken
            Group {
                if let status = dayStatus(for: date) {
                    Circle().fill(status.color)
                } else {
                    Rectangle().fill(Color.clear)
                }
            }
            .frame(width: 10, height: 10)
        }
        .padding(8)
        .background(isDoseDay(date) ? Color(UIColor.systemBackground).opacity(0.2) : Color.clear)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isCurrentDay(date) ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
    
    private func dayOfWeekSymbol(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        return dateFormatter.string(from: date)
    }
    
    private func dayOfMonth(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("d")
        return dateFormatter.string(from: date)
    }
    
    private func dosesForDate(_ date: Date) -> [Dose] {
        drug.doses.filter { Calendar.current.isDate($0.time, inSameDayAs: date) }
    }

    private func isDoseDay(_ date: Date) -> Bool {
        drug.doses.contains { Calendar.current.isDate($0.time, inSameDayAs: date) }
    }

    private enum DayStatus {
        case allTaken, partial, noneTaken
        var color: Color {
            switch self {
            case .allTaken: return .green
            case .partial: return .orange
            case .noneTaken: return Color(UIColor.systemRed)
            }
        }
    }

    private func dayStatus(for date: Date) -> DayStatus? {
        let doses = dosesForDate(date)
        guard !doses.isEmpty else { return nil }
        let takenCount = doses.filter { $0.timeTaken != nil }.count
        if takenCount == doses.count { return .allTaken }
        if takenCount == 0 { return .noneTaken }
        return .partial
    }
    
    private func isCurrentDay(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}
