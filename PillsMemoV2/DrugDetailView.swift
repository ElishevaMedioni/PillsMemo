//
//  DrugDetailView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 03/03/2025.
//


import SwiftUI
import UserNotifications

struct DrugDetailView: View {
    
    
    @State private var selectedColor: Color = .white
    @Bindable var drug: Drug
    @State private var selectedTab: Int
    
    init(drug: Drug, initialTab: Int = 0) {
        self.drug = drug
        _selectedTab = State(initialValue: initialTab)
    }
    
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // first tab
            VStack {
                DrugDoseScheduleView(drug: drug)
                    .padding(.horizontal, 5)
                Spacer()
            }
            .tabItem {
                Label("Dose Schedule", systemImage: "calendar")
            }
            .tag(0)
            
            // second tab
            DrugEditorView(drug: drug)
            .tabItem {
                Label("Details", systemImage: "info.circle")
            }
            .tag(1)
        }
        .onAppear {
            drug.sortDoses()
            // Set the initial selected color when the view appears
            self.selectedColor = Color(drug.color)
        }
        .navigationTitle(drug.title.isEmpty ? "New Medication" : drug.title)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct DrugEditor_Previews: PreviewProvider {
//    static var newDrug = Drug(
//        color: ColorOptions.random().rgbaColor,
//        title: "",
//        drugType: .Pills,
//        quantity: "",
//        frequency: .daily,
//        duration: .oneDay,
//        doses: [],
//        notes: ""
//    )
//    static var previews: some View {
//        DrugDetailView(drug: newDrug)
//    }
//}
