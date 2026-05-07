//
//  NotificationPermissionView.swift
//  PillsMemoV2
//
//  Shown before calling requestAuthorization() so the user understands why we ask.
//  Apple rejects apps that trigger the system permission prompt with no context.
//

import SwiftUI
import UserNotifications
import UIKit

struct NotificationPermissionView: View {
    @Environment(\.dismiss) private var dismiss

    /// Called after the user decides. `granted = true` means they accepted in the
    /// system prompt (or had already accepted). `granted = false` for denial.
    var onDecision: (_ granted: Bool) -> Void

    @State private var currentStatus: UNAuthorizationStatus = .notDetermined

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)
                    .padding(.top, 24)
                    .accessibilityHidden(true)

                Text("Never miss a dose")
                    .font(.title).bold()
                    .multilineTextAlignment(.center)

                Text("PillsMemo sends a local reminder at each scheduled dose time. Notifications stay on your device — we never send them to a server.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                Spacer()

                if currentStatus == .denied {
                    deniedActions
                } else {
                    primaryActions
                }
            }
            .padding(24)
            .navigationTitle("Reminders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not now") {
                        onDecision(false)
                        dismiss()
                    }
                }
            }
            .task { await refreshStatus() }
        }
    }

    private var primaryActions: some View {
        Button {
            Task { await requestPermission() }
        } label: {
            Text("Enable reminders")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
        }
        .buttonStyle(.borderedProminent)
    }

    private var deniedActions: some View {
        VStack(spacing: 12) {
            Text("Notifications are disabled for PillsMemo. Open Settings to enable them.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 50)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func refreshStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run { currentStatus = settings.authorizationStatus }
    }

    private func requestPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                onDecision(granted)
                dismiss()
            }
        } catch {
            await MainActor.run {
                onDecision(false)
                dismiss()
            }
        }
    }
}

#Preview {
    NotificationPermissionView { _ in }
}
