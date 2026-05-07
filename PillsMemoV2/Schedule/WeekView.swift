//
//  WeekView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 30/03/2025.
//

import SwiftUI

// Subview for a single week
struct WeekView: View {
    let weekOffset: Int
    let drug: Drug
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)) {
            ForEach(weekDates, id: \.self) { date in
                DayCell(date: date, drug: drug)
            }
        }
        .padding(.horizontal, 7)
    }
    
    // Compute the dates for the current week
        private var weekDates: [Date] {
            let calendar = Calendar.current
            var dates: [Date] = []
            
            guard let baseDate = calendar.date(byAdding: .day, value: weekOffset * 7, to: Date()) else {
                return []
            }
            
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate)) else {
                return []
            }
            
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                    dates.append(date)
                }
            }
            
            return dates
        }
}
