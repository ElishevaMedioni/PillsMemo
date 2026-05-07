//
//  NotificationManager.swift
//  PillsMemoV2
//
//  Rolling-window scheduling. iOS caps pending notifications at 64 per app,
//  so we schedule only the next N future, untaken doses per drug (N = 20)
//  and refresh the window whenever the app becomes active.
//
//  Notification identifiers are prefixed with the drug's UUID so we can
//  cancel all of a drug's reminders without needing to know each dose's id
//  (important since calculateDoses() regenerates Dose instances with new ids).
//

import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    /// Max pending notifications to schedule per drug. Keeps total app-wide
    /// pending count safely under iOS's 64 cap across several drugs.
    private let maxPendingPerDrug = 20

    // MARK: - Public API (fire-and-forget)

    func scheduleNotifications(for drug: Drug) {
        let snapshot = DrugSnapshot(drug: drug)
        Task { await reschedule(snapshot) }
    }

    func cancelNotifications(for drug: Drug) {
        let drugID = drug.id
        Task { await cancel(drugID: drugID) }
    }

    /// Re-schedule every enabled drug. Call on app launch and when the app
    /// returns to foreground so the rolling window advances.
    func refreshAll(drugs: [Drug]) {
        let snapshots = drugs
            .filter(\.notificationsEnabled)
            .map(DrugSnapshot.init)
        Task {
            for snapshot in snapshots {
                await reschedule(snapshot)
            }
        }
    }

    // MARK: - Internals

    private func reschedule(_ snapshot: DrugSnapshot) async {
        await cancel(drugID: snapshot.id)

        let center = UNUserNotificationCenter.current()
        let now = Date()
        let upcoming = snapshot.doses
            .filter { $0.time > now && $0.timeTaken == nil }
            .sorted { $0.time < $1.time }
            .prefix(maxPendingPerDrug)

        let calendar = Calendar.current
        for dose in upcoming {
            let content = UNMutableNotificationContent()
            content.title = "Time for your medication"
            content.body = "Don't forget to take your \(snapshot.title)"
            content.sound = .default

            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dose.time)
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components, repeats: false)

            let request = UNNotificationRequest(
                identifier: identifier(drugID: snapshot.id, doseID: dose.id),
                content: content,
                trigger: trigger)

            try? await center.add(request)
        }
        // TEMPORARY — remove before shipping
        let allPending = await center.pendingNotificationRequests()
        print("📬 [\(snapshot.title)] scheduled \(upcoming.count) — total pending app-wide: \(allPending.count)")
    }

    private func cancel(drugID: UUID) async {
        let center = UNUserNotificationCenter.current()
        let prefix = drugID.uuidString
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { $0.hasPrefix(prefix) }
        if !ids.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: ids)
        }
    }

    private func identifier(drugID: UUID, doseID: UUID) -> String {
        "\(drugID.uuidString)::\(doseID.uuidString)"
    }
}

// MARK: - Thread-safe snapshot

/// A value-type copy of the drug fields we need for scheduling. Lets us hop
/// into a background Task without touching the @Model object from another
/// actor (SwiftData models must be accessed on the context that owns them).
private struct DrugSnapshot {
    let id: UUID
    let title: String
    let doses: [DoseSnapshot]

    init(drug: Drug) {
        self.id = drug.id
        self.title = drug.title
        self.doses = drug.doses.map(DoseSnapshot.init)
    }
}

private struct DoseSnapshot {
    let id: UUID
    let time: Date
    let timeTaken: Date?

    init(_ dose: Dose) {
        self.id = dose.id
        self.time = dose.time
        self.timeTaken = dose.timeTaken
    }
}
