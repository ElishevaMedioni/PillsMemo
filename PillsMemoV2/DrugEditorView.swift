//
//  DrugEditorView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 30/03/2025.
//

import SwiftUI
import UserNotifications

struct DrugEditorView: View {

    enum Field: Hashable {
        case title
        case quantity
        case notes
    }

    @Bindable var drug: Drug
    @FocusState private var fieldIsFocused: Field?
    @State private var selectedColor: Color = .white
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var showingPermissionSheet = false
    
    var body: some View {
        ZStack {
            Form {
                    TextField("New Drug", text: $drug.title)
                    .focused($fieldIsFocused, equals: .title)
                        .font(.title2)
                        .padding(5)
                        .disableAutocorrection(true)
                    
                    Section() {
                        Picker("Drug Type", selection: $drug.drugType) {
                            ForEach(DrugType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    }
                    
                    Section(header: Text("Quantity")) {
                        TextField("" ,text:$drug.quantity)
                            .keyboardType(.decimalPad)
                            .focused($fieldIsFocused, equals: .quantity)

                    }
                    
                    
                    Section(header: Text("Color")) {
                        ColorPickerView(selectedColor: $selectedColor, rgbaColor: $drug.color)
                    }
                    
                    Section {
                        
                        DatePicker("Start Date", selection: $drug.startDate)
                            .listRowSeparator(.hidden)
                            .onChange(of: drug.startDate) { _, _ in
                                regenerateSchedule()
                            }

                        Picker("Frequency", selection: $drug.frequency) {
                            ForEach(Frequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue).tag(frequency)
                            }
                        }
                        .onChange(of: drug.frequency) { _, _ in
                            regenerateSchedule()
                        }

                        Picker("Duration", selection: $drug.duration) {
                            ForEach(Duration.allCases, id: \.self) { duration in
                                Text(duration.rawValue).tag(duration)
                            }
                        }
                        .onChange(of: drug.duration) { _, _ in
                            regenerateSchedule()
                        }
                    }
                    
                Section(header: Text("Notes")) {
                    TextEditor( text:$drug.notes)
                        .focused($fieldIsFocused, equals: .notes)
                        .frame(minHeight: 70)
                }
                    
                    Section {
                        Toggle("Enable Notifications", isOn: $drug.notificationsEnabled)
                            .onChange(of: drug.notificationsEnabled) { _, newValue in
                                if newValue {
                                    handleEnableNotifications()
                                } else {
                                    NotificationManager.shared.cancelNotifications(for: drug)
                                }
                            }
                    }
            }
            if fieldIsFocused != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        fieldIsFocused = nil
                    }
            }
        }
        .sheet(isPresented: $showingPermissionSheet) {
            NotificationPermissionView { granted in
                if granted {
                    NotificationManager.shared.scheduleNotifications(for: drug)
                } else {
                    drug.notificationsEnabled = false
                }
            }
        }
        .alert("Notifications", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    /// Regenerates doses after a schedule change (startDate / frequency / duration)
    /// and reschedules notifications. `calculateDoses()` wipes the old Dose
    /// instances, so we must cancel any pending notifications *before* the
    /// UUIDs change — `NotificationManager.cancelNotifications(for:)` uses
    /// the drug's id as a prefix, so it works regardless.
    private func regenerateSchedule() {
        drug.calculateDoses()
        if drug.notificationsEnabled {
            NotificationManager.shared.scheduleNotifications(for: drug)
        } else {
            NotificationManager.shared.cancelNotifications(for: drug)
        }
    }

    private func handleEnableNotifications() {
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            await MainActor.run {
                switch settings.authorizationStatus {
                case .notDetermined:
                    showingPermissionSheet = true
                case .denied:
                    drug.notificationsEnabled = false
                    alertMessage = "Notifications are disabled for PillsMemo. Enable them in Settings to receive dose reminders."
                    showingAlert = true
                case .authorized, .provisional, .ephemeral:
                    NotificationManager.shared.scheduleNotifications(for: drug)
                @unknown default:
                    showingPermissionSheet = true
                }
            }
        }
    }
}

#Preview {
    //DrugEditorView()
}

extension View {
    func hideKeyboardWhenTappedAround() -> some View  {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                  to: nil, from: nil, for: nil)
        }
    }
}
