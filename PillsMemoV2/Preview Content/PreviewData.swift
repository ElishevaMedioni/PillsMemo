//
//  PreviewData.swift
//  PillsMemoV2
//
//  Mock data for SwiftUI previews only. This file lives in "Preview Content"
//  so it's excluded from release builds.
//
//  Usage in a preview:
//
      #Preview {
          DrugDetailView(drug: PreviewData.aspirin)
              .modelContainer(PreviewData.container)
      }
//

import Foundation
import SwiftData
import SwiftUI

enum PreviewData {

    // MARK: - Individual drugs

    /// Daily drug started 3 days ago. First two doses taken, rest untouched.
    /// Good for previewing the dose schedule with a mix of past/future states.
    static var aspirin: Drug {
        let drug = Drug(
            color: Color.red.rgbaColor,
            title: "Aspirin",
            drugType: .Pills,
            quantity: "100",
            frequency: .daily,
            duration: .oneWeek,
            notificationsEnabled: true,
            startDate: startOfToday.addingTimeInterval(-3 * dayInSeconds),
            doses: [],
            notes: "Take with food."
        )
        drug.calculateDoses()
        if drug.doses.count >= 2 {
            drug.doses[0].timeTaken = drug.doses[0].time.addingTimeInterval(60)
            drug.doses[1].timeTaken = drug.doses[1].time.addingTimeInterval(120)
        }
        return drug
    }

    /// Every-8-hours vitamin started today. Only the first dose of today is taken —
    /// gives the DayCell a partial (orange) state.
    static var vitamins: Drug {
        let drug = Drug(
            color: Color.orange.rgbaColor,
            title: "Multivitamin",
            drugType: .Vitamins,
            quantity: "60",
            frequency: .every8Hours,
            duration: .oneMonth,
            notificationsEnabled: false,
            startDate: startOfToday,
            doses: [],
            notes: ""
        )
        drug.calculateDoses()
        if let first = drug.doses.first(where: { Calendar.current.isDateInToday($0.time) }) {
            first.timeTaken = first.time.addingTimeInterval(90)
        }
        return drug
    }

    /// Antibiotic course finished 3 days ago — every dose marked taken.
    /// Useful for previewing the "all doses completed" copy and all-green DayCells.
    static var completedDrug: Drug {
        let drug = Drug(
            color: Color.green.rgbaColor,
            title: "Antibiotic",
            drugType: .Pills,
            quantity: "14",
            frequency: .every12Hours,
            duration: .oneWeek,
            notificationsEnabled: false,
            startDate: startOfToday.addingTimeInterval(-10 * dayInSeconds),
            doses: [],
            notes: "Finish the full course."
        )
        drug.calculateDoses()
        for dose in drug.doses {
            dose.timeTaken = dose.time.addingTimeInterval(300)
        }
        return drug
    }

    /// A blank drug — for DrugEditorView previews where you want to test the empty form.
    static var emptyDrug: Drug {
        Drug(
            color: ColorOptions.random().rgbaColor,
            title: "",
            drugType: .Pills,
            quantity: "",
            frequency: .daily,
            duration: .oneWeek,
            doses: [],
            notes: ""
        )
    }

    // MARK: - Full preview container

    /// In-memory ModelContainer pre-populated with several drugs.
    /// Attach with `.modelContainer(PreviewData.container)` on any preview.
    @MainActor
    static let container: ModelContainer = {
        let schema = Schema([Drug.self, Dose.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: schema, configurations: config)
            container.mainContext.insert(aspirin)
            container.mainContext.insert(vitamins)
            container.mainContext.insert(completedDrug)
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()

    // MARK: - Helpers

    private static let dayInSeconds: TimeInterval = 86_400

    private static var startOfToday: Date {
        Calendar.current.startOfDay(for: Date())
    }
}
