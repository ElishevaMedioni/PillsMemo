//
//  DisclaimerView.swift
//  PillsMemoV2
//
//  Shown once on first launch. User must acknowledge before entering the app.
//  Required by App Review for health/medical-adjacent apps.
//

import SwiftUI

struct DisclaimerView: View {
    @Binding var hasAccepted: Bool
    @State private var acknowledged = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    disclaimerCard(
                        icon: "cross.case.fill",
                        title: "Not a medical device",
                        body: "PillsMemo is a reminder tool. It does not diagnose, treat, or prevent any medical condition."
                    )

                    disclaimerCard(
                        icon: "stethoscope",
                        title: "Follow your provider",
                        body: "Always follow your healthcare provider's instructions. Consult them before changing any medication or schedule."
                    )

                    disclaimerCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Not for emergencies",
                        body: "In a medical emergency, call your local emergency number. Do not rely on this app for urgent care."
                    )

                    disclaimerCard(
                        icon: "lock.shield.fill",
                        title: "Your data stays on device",
                        body: "Your medication list is stored locally. PillsMemo does not send your data to any server."
                    )

                    Toggle(isOn: $acknowledged) {
                        Text("I understand PillsMemo is a reminder tool, not medical advice.")
                            .font(.footnote)
                    }
                    .padding(.top, 8)

                    Button {
                        hasAccepted = true
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!acknowledged)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "pills.fill")
                .font(.system(size: 56))
                .foregroundStyle(.tint)
                .padding(.top, 8)
            Text("Before you start")
                .font(.title2).bold()
            Text("A few things to know about PillsMemo.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func disclaimerCard(icon: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 32)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(body).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DisclaimerView(hasAccepted: .constant(false))
}
