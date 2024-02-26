import SwiftUI

class DrugData: ObservableObject {
    
    @Published var drugs: [Drug] = [
        Drug(color: Color.red.rgbaColor,
              title: "Prednisone",
             drugType: .Pills,
             quantity: "10mg",
             frequency: .daily,
             duration: .fiveDays,
              notificationsEnabled: false,
              startDate: Date.roundedHoursFromNow(60 * 60 * 24 * 30)
            ),
        Drug(color: Color.yellow.rgbaColor,
              title: "Hyrimoz",
              drugType: .Injection,
             quantity: "1",
             frequency: .every10Days,
             duration: .oneMonth,
              notificationsEnabled: false,
              startDate: Date.roundedHoursFromNow(60 * 60 * 20)
            ),
        Drug(color: Color.orange.rgbaColor,
              title: "Vitamin D",
              drugType: .Vitamins,
             quantity: "2",
             frequency: .daily,
             duration: .oneWeek,
              notificationsEnabled: false,
              startDate: Date.roundedHoursFromNow(60 * 60 * 24 * 19)
            )
    ]
    
    
    func add(_ drug: Drug) {
        drugs.append(drug)
    }
    
    func remove(_ drug: Drug) {
        drugs.removeAll { $0.id == drug.id}
    }
    
    func sortedDrugs(period: Period) -> Binding<[Drug]> {
        Binding<[Drug]>(
            get: {
                self.drugs
                    .filter { $0.period == period}
                    .sorted { $0.startDate < $1.startDate }
            },
            set: { drugs in
                for drug in drugs {
                    if let index = self.drugs.firstIndex(where: { $0.id == drug.id }) {
                        self.drugs[index] = drug
                    }
                }
            }
        )
    }
    
    
    func getBindingToDrug(_ drug: Drug) -> Binding<Drug>? {
        Binding<Drug>(
            get: {
                guard let index = self.drugs.firstIndex(where: { $0.id == drug.id }) else { return Drug.delete }
                return self.drugs[index]
            },
            set: { drug in
                guard let index = self.drugs.firstIndex(where: { $0.id == drug.id }) else { return }
                self.drugs[index] = drug
            }
        )
    }
    
    private static func getDrugsFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("drugs.data")
    }
   
    func load() {
        do {
            
            let fileURL = try DrugData.getDrugsFileURL()
            let data = try Data(contentsOf: fileURL)

            drugs = try JSONDecoder().decode([Drug].self, from: data)
            
            print("Drugs loaded: \(drugs.count)")
        } catch {
            
            print("Failed to load from file. Backup data used")
            
        }
    }
    
   
    func save() {
        do {
            let fileURL = try DrugData.getDrugsFileURL()
            let data = try JSONEncoder().encode(drugs)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            
            print("Events saved")
        } catch {
            
            print("Unable to save")
            
        }
    }
}

enum Period: String, CaseIterable, Identifiable {
    case today = "Today"
    case future = "Future"
    case past = "Past"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue }
}



extension Date {
    static func from(month: Int, day: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            return Date.now
        }
    }
    
    static func roundedHoursFromNow(_ hours: Double) -> Date {
        let exactDate = Date(timeIntervalSinceNow: hours)
        guard let hourRange = Calendar.current.dateInterval(of: .hour, for: exactDate) else {
            return exactDate
        }
        return hourRange.end
    }
}
