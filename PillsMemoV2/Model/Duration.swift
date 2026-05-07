//
//  Duration.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import Foundation

enum Duration: String, Codable, CaseIterable {
    case oneDay = "1 Day"
    case twoDays = "2 Days"
    case threeDays = "3 Days"
    case fourDays = "4 Days"
    case fiveDays = "5 Days"
    case sixDays = "6 Days"
    case oneWeek = "1 Week"
    case twoWeeks = "2 Weeks"
    case threeWeeks = "3 Weeks"
    case oneMonth = "1 Month"
    case twoMonths = "2 Months"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case oneYear = "1 Year"

    /// DateComponents to add to a start date to get the end date. Uses real
    /// calendar units (.month / .year) so months and years match the actual
    /// calendar — no more 30-day / 365-day approximations.
    var dateComponents: DateComponents {
        switch self {
        case .oneDay:      return DateComponents(day: 1)
        case .twoDays:     return DateComponents(day: 2)
        case .threeDays:   return DateComponents(day: 3)
        case .fourDays:    return DateComponents(day: 4)
        case .fiveDays:    return DateComponents(day: 5)
        case .sixDays:     return DateComponents(day: 6)
        case .oneWeek:     return DateComponents(day: 7)
        case .twoWeeks:    return DateComponents(day: 14)
        case .threeWeeks:  return DateComponents(day: 21)
        case .oneMonth:    return DateComponents(month: 1)
        case .twoMonths:   return DateComponents(month: 2)
        case .threeMonths: return DateComponents(month: 3)
        case .sixMonths:   return DateComponents(month: 6)
        case .oneYear:     return DateComponents(year: 1)
        }
    }
}
