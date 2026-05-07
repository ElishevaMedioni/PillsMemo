//
//  Drug.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import Foundation
import SwiftData

@Model
class Drug: Identifiable {
    var id = UUID()
    var symbol: String {
        drugType.symbol // This accesses the symbol of the enum instance
    }
    var color: RGBAColor = ColorOptions.random().rgbaColor
    var title : String
    var drugType: DrugType = DrugType.Pills
    var quantity : String
    var frequency: Frequency = Frequency.daily
    var duration: Duration = Duration.oneDay
    var notificationsEnabled = false
    var startDate = Date.now
    var doses: [Dose] = []
    var notes : String
    
    init(id: UUID = UUID(), color: RGBAColor, title: String, drugType: DrugType, quantity: String, frequency: Frequency, duration: Duration, notificationsEnabled: Bool = false, startDate: Foundation.Date = Date.now, doses: [Dose], notes: String) {
        self.id = id
        self.color = color
        self.title = title
        self.drugType = drugType
        self.quantity = quantity
        self.frequency = frequency
        self.duration = duration
        self.notificationsEnabled = notificationsEnabled
        self.startDate = startDate
        self.doses = doses
        self.notes = notes
    }
    

    func calculateDoses() {
        doses.removeAll()
        let calendar = Calendar.current
        var currentDate = startDate
        
        // Add the first dose (startDate)
        let firstDose = Dose(time: currentDate, timeTaken: nil)
        doses.append(firstDose)
        
        // Calculate the end date using real calendar components so months
        // and years respect actual month lengths / leap years.
        guard let endDate = calendar.date(byAdding: duration.dateComponents, to: startDate) else {
            return
        }
        
        // Append a dose only if its time falls on or before endDate.
        // Using nextDoseDate in the condition (not currentDate) avoids an
        // off-by-one where the loop would run one extra step past endDate.
        while let nextDoseDate = frequency.nextDoseTime(from: currentDate),
              nextDoseDate <= endDate {
            doses.append(Dose(time: nextDoseDate, timeTaken: nil))
            currentDate = nextDoseDate
        }
        
        doses.sort { $0.time < $1.time }
    }
    
    func sortDoses() {
        doses.sort { $0.time < $1.time }
    }
    
    
}
