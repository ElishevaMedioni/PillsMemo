import SwiftUI

enum DrugType: String, Codable, CaseIterable {
    case Pills, Drop, Injection, Vitamins
    
    var symbol: String {
        switch self {
        case .Pills: return "pills"
        case .Drop: return "drop"
        case .Injection: return "syringe"
        case .Vitamins: return "pill.circle"
        }
    }
}

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
            return calendar.date(byAdding: .day, value: 30, to: startDate)
            
        }
    }
}

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
    
    // Computed property to convert Duration to a number of days
    var numberOfDays: Int {
        switch self {
        case .oneDay:
            return 1
        case .twoDays:
            return 2
        case .threeDays:
            return 3
        case .fourDays:
            return 4
        case .fiveDays:
            return 5
        case .sixDays:
            return 6
        case .oneWeek:
            return 7
        case .twoWeeks:
            return 14
        case .threeWeeks:
            return 21
        case .oneMonth:
            return 30 // Approximation, assuming a month has 30 days
        case .twoMonths:
            return 60 // Approximation, assuming a month has 30 days
        case .threeMonths:
            return 90 // Approximation, assuming a month has 30 days
        case .sixMonths:
            return 180 // Approximation, assuming a month has 30 days
        case .oneYear:
            return 365 // Not accounting for leap years
        }
    }
}


struct Drug: Identifiable, Hashable, Codable {
    var id = UUID()
    var symbol: String {
        drugType.symbol // This accesses the symbol of the enum instance
    }
    var color: RGBAColor = ColorOptions.random().rgbaColor
    var title = ""
    var drugType: DrugType = .Pills // Default to Pills
    var quantity = ""
    var frequency: Frequency = .daily
    var duration: Duration = .oneDay
    var notificationsEnabled = false
    var startDate = Date.now
    var doses: [Dose] = []
    var notes = ""
    
    
    var period: Period {
        let calendar = Calendar.current
        let now = Date()
        if calendar.isDate(startDate, inSameDayAs: now) {
            return .today
        }
        else if startDate < Date.now{
            return .past
            
        }  else {
            return .future
        }
    }
    
    mutating func calculateDoses() {
        doses.removeAll()
        let calendar = Calendar.current
        var currentDate = startDate
        
        // Calculate the end date based on the duration
        guard let endDate = calendar.date(byAdding: .day, value: duration.numberOfDays, to: startDate) else {
            return // Handle the error appropriately
        }
        
        while currentDate <= endDate {
            if let nextDoseDate = frequency.nextDoseTime(from: currentDate) {
                let newDose = Dose(time: nextDoseDate, taken: false)
                doses.append(newDose)
                currentDate = nextDoseDate
            } else {
                break // Exit the loop if the next dose date can't be calculated
            }
        }
    }

    
    static var example = Drug(
        title: "Acamol",
        drugType: .Pills,
        quantity: "1",
        frequency: .daily,
        duration: .oneDay,
        notificationsEnabled: false,
        startDate: Date(timeIntervalSinceNow: 60 * 60 * 24 * 365 * 1.5),
        doses: [] 
    )
    
    static var delete = Drug()
}

// Convenience methods for dates.
extension Date {
    var sevenDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: self) ?? self
    }
    
    var thirtyDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: self) ?? self
    }
}

