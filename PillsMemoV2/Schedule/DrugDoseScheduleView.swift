//
//  DrugDoseScheduleView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 27/03/2025.
//


import SwiftUI

struct DrugDoseScheduleView: View {
    @Bindable var drug: Drug
    @State private var currentWeek: Date = Date()
    @State private var weekOffset: Int = 0
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack {
            //headerView
            weekNavigationView
            .padding()
            weeklyCalendarView
            dosesListView
        }
    }
    
    // MARK: - Component Views
    
    private var headerView: some View {
        HStack {
            Image(systemName: drug.symbol)
                .foregroundStyle(Color(drug.color))
            
            Text(drug.title)
                .font(.title2)
                .bold()
        }
    }
    
    private var weekNavigationView: some View {
        HStack {
            Button(action: {
                hapticFeedback.impactOccurred()
                weekOffset -= 1
                updateCurrentWeek()
            }) {
                Image(systemName: "chevron.left")
            }
            
            Text(weekRangeText)
                .font(.headline)
            
            Button(action: {
                hapticFeedback.impactOccurred()
                weekOffset += 1
                updateCurrentWeek()
            }) {
                Image(systemName: "chevron.right")
            }
        }
    }
    
    private var weeklyCalendarView: some View {
        TabView(selection: $weekOffset) {
            ForEach(-12...12, id: \.self) { offset in
                WeekView(weekOffset: offset, drug: drug)
                    .tag(offset)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 120)
        .onChange(of: weekOffset) { _, newValue in
            updateCurrentWeek()
        }
    }
    
    private var dosesListView: some View {
        ZStack {
            List {
                ForEach(weekDoses, id: \.id) { dose in
                    DoseRowView(dose: dose, drug: drug, hapticFeedback: hapticFeedback)
                }
            }
            .listStyle(PlainListStyle())

            if weekDoses.isEmpty {
                EmptyState(imageName: "empty-drugs", message: "no doses")
            }
        }
    }
    
    
    // Compute the dates for the current week
    private var weekDates: [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentWeek)) else {
            return []
        }
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    private func updateCurrentWeek() {
        if let newDate = Calendar.current.date(byAdding: .day, value: weekOffset * 7, to: Date()) {
            currentWeek = newDate
        }
    }
    
    // Compute doses for the current week. Always sort here — SwiftData to-many
    // relationships are unordered and may return a shuffled array after mutations.
    private var weekDoses: [Dose] {
        let calendar = Calendar.current
        return drug.doses
            .filter { dose in
                weekDates.contains { calendar.isDate(dose.time, inSameDayAs: $0) }
            }
            .sorted { $0.time < $1.time }
    }
    
    // Helper methods
        
    private var weekRangeText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        guard let firstDate = weekDates.first, let lastDate = weekDates.last else {
            return ""
        }
        return "\(dateFormatter.string(from: firstDate)) - \(dateFormatter.string(from: lastDate))"
    }
}

// MARK: - Previews

struct DrugDoseScheduleView_Previews: PreviewProvider {
    static var newDrug: Drug = {
        let drug = Drug(
            color: ColorOptions.random().rgbaColor,
            title: "Aspirin",
            drugType: .Pills,
            quantity: "100mg",
            frequency: .daily,
            duration: .oneWeek,
            doses: [],
            notes: "Take with food"
        )
        
        // Manually set start date to beginning of current week
        let calendar = Calendar.current
        let today = Date()
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) {
            drug.startDate = startOfWeek
        }
        
        // Calculate doses
        drug.calculateDoses()
        
        // Manually modify some doses for preview demonstration
        if !drug.doses.isEmpty {
            // Mark some doses as taken
            drug.doses[1].timeTaken = drug.doses[1].time
            drug.doses[3].timeTaken = drug.doses[3].time
        }
        
        return drug
    }()
    
    static var previews: some View {
        DrugDoseScheduleView(drug: newDrug)
            .modelContainer(for: Drug.self, inMemory: true)
    }
}
