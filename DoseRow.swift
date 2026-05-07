import SwiftUI

struct DoseRow: View {
    @Binding var dose: Dose
    var body: some View {
        HStack {
            Button(action: {
                dose.taken.toggle()
            }) {
                Image(systemName: dose.taken ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)
            
            DatePicker("", selection: $dose.time, displayedComponents: .date)
                .labelsHidden()
            DatePicker("", selection: $dose.time, displayedComponents: .hourAndMinute)
                .labelsHidden()
            Spacer()
        }
    }
}
