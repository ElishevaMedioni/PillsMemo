//
//  Frequency.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import Foundation

enum Frequency: String, Codable, CaseIterable {
    case everyHour = "Every Hour"
    case every2Hours = "Every 2 Hours"
    case every3Hours = "Every 3 Hours"
    case every4Hours = "Every 4 Hours"
    case every5Hours = "Every 5 Hours"
    case every6Hours = "Every 6 Hours"
    case every8Hours = "Every 8 Hours"
    case every10Hours = "Every 10 Hours"
    case every12Hours = "Every 12 Hours"
    case daily = "Daily"
    case every2Days = "Every 2 Days"
    case every3Days = "Every 3 Days"
    case every4Days = "Every 4 Days"
    case every5Days = "Every 5 Days"
    case every6Days = "Every 6 Days"
    case weekly = "Weekly"
    case every10Days = "Every 10 Days"
    case every2Weeks = "Every 2 Weeks"
    case every3Weeks = "Every 3 Weeks"
    case everyMonth = "Every Month"
    
    func nextDoseTime(from startDate: Date) -> Date? {
        let calendar = Calendar.current
        
        switch self {
        case .everyHour:
            return calendar.date(byAdding: .hour, value: 1, to: startDate)
        case .every2Hours:
            return calendar.date(byAdding: .hour, value: 2, to: startDate)
        case .every3Hours:
            return calendar.date(byAdding: .hour, value: 3, to: startDate)
        case .every4Hours:
            return calendar.date(byAdding: .hour, value: 4, to: startDate)
        case .every5Hours:
            return calendar.date(byAdding: .hour, value: 5, to: startDate)
        case .every6Hours:
            return calendar.date(byAdding: .hour, value: 6, to: startDate)
        case .every8Hours:
            return calendar.date(byAdding: .hour, value: 8, to: startDate)
        case .every10Hours:
            return calendar.date(byAdding: .hour, value: 10, to: startDate)
        case .every12Hours:
            return calendar.date(byAdding: .hour, value: 12, to: startDate)
        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: startDate)
        case .every2Days:
            return calendar.date(byAdding: .day, value: 2, to: startDate)
        case .every3Days:
            return calendar.date(byAdding: .day, value: 3, to: startDate)
        case .every4Days:
            return calendar.date(byAdding: .day, value: 4, to: startDate)
        case .every5Days:
            return calendar.date(byAdding: .day, value: 5, to: startDate)
        case .every6Days:
            return calendar.date(byAdding: .day, value: 6, to: startDate)
        case .weekly:
            return calendar.date(byAdding: .day, value: 7, to: startDate)
        case .every10Days:
            return calendar.date(byAdding: .day, value: 10, to: startDate)
        case .every2Weeks:
            return calendar.date(byAdding: .day, value: 14, to: startDate)
        case .every3Weeks:
            return calendar.date(byAdding: .day, value: 21, to: startDate)
        case .everyMonth:
            return calendar.date(byAdding: .month, value: 1, to: startDate)
            
        }
    }
    
    
}
