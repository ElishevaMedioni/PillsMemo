import SwiftUI
import UserNotifications

struct DrugEditor: View {
    @State private var selectedColor: Color = .white
    @Binding var drug: Drug
    @State var isNew = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            List {
                TextField("New Drug", text: $drug.title)
                    .font(.title2)
                    .padding(.top, 5)
                
                Section() {
                    Picker("Drug Type", selection: $drug.drugType) {
                        ForEach(DrugType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Quantity")) {
                    TextEditor( text:$drug.quantity)
                }
                
                Section(header: Text("Color")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                        ForEach(ColorOptions.all, id: \.self) { colorOption in
                            ZStack {
                                Circle()
                                    .fill(colorOption)
                                    .frame(width: 36, height: 36)
                                    .onTapGesture {
                                        // When a color is tapped, update the selectedColor and the drug's color
                                        self.selectedColor = colorOption
                                        drug.color = colorOption.rgbaColor
                                    }
                                // Checkmark for the selected color
                                if selectedColor == colorOption {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    
                    DatePicker("Start Date", selection: $drug.startDate)
                        .listRowSeparator(.hidden)
                        .onChange(of: drug.startDate) { _ in
                            drug.calculateDoses()
                        }

                    Picker("Frequency", selection: $drug.frequency) {
                        ForEach(Frequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    
                    Picker("Duration", selection: $drug.duration) {
                        ForEach(Duration.allCases, id: \.self) { duration in
                            Text(duration.rawValue).tag(duration)
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor( text:$drug.notes)
                    .frame(minHeight: 100)
                        
                }
                
                Section {
                    Toggle("Enable Notifications", isOn: $drug.notificationsEnabled)
                        .onChange(of: drug.notificationsEnabled) { isEnabled in
                            if isEnabled {
                                NotificationManager.shared.requestAuthorization { granted in
                                    if granted {
                                        // Schedule a notification for each dose
                                        NotificationManager.shared.scheduleNotifications(for: drug)
                                    } else {
                                        // Permission denied, show alert and toggle off
                                        DispatchQueue.main.async {
                                            self.drug.notificationsEnabled = false
                                            self.alertMessage = "Permission denied. Please enable notifications in your device settings."
                                            self.showingAlert = true
                                        }
                                    }
                                }
                            } else {
                                // Notifications are disabled, remove any scheduled notifications
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        }
                }
                
                Section(header: Text("Dose Schedule")) {
                    ForEach($drug.doses.indices, id: \.self) { index in
                        DoseRow(dose: $drug.doses[index])
                    }
                }
            }
        }
        .onAppear {
            // Set the initial selected color when the view appears
            self.selectedColor = Color(drug.color)
        }
                
        #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct DrugEditor_Previews: PreviewProvider {
    static var previews: some View {
        DrugEditor(drug: .constant(Drug()), isNew: true)
            .environmentObject(DrugData())
    }
}
