//
//  PillsMemoV2App.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import SwiftUI
import SwiftData

@main
struct PillsMemoV2App: App {
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @Environment(\.scenePhase) private var scenePhase

    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Drug.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if hasAcceptedDisclaimer {
                    DrugsListView()
                } else {
                    DisclaimerView(hasAccepted: $hasAcceptedDisclaimer)
                }
            }
            .modelContainer(container)
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    refreshNotifications()
                }
            }
        }
    }

    /// Rolls the notification window forward every time the app becomes active,
    /// so daily/weekly drugs keep getting reminders beyond the first 20 doses.
    @MainActor
    private func refreshNotifications() {
        do {
            let drugs = try container.mainContext.fetch(FetchDescriptor<Drug>())
            NotificationManager.shared.refreshAll(drugs: drugs)
        } catch {
            // Silent failure is acceptable here — the next scene-phase change retries.
        }
    }
}
