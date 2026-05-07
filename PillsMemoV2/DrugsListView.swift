//
//  DrugsListView.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import SwiftUI
import SwiftData

struct DrugsListView: View {
    
    @Query(sort: \Drug.startDate) var drugs: [Drug]
    @Environment(\.modelContext) private var context
    
    @State private var isAddingNewDrug = false
    @State private var selection: Drug?
    
    @State private var newDrugID: UUID? = nil
    
    var body: some View {
        NavigationSplitView {
            
            ZStack {
                
                VStack {
                    List(selection: $selection)  {
                        ForEach(drugs) { drug in
                            DrugRowView(drug: drug)
                                .tag(drug)
                                .onAppear {
                                    drug.sortDoses()
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        selection = nil
                                        context.delete(drug)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    selection = drug
                                }
                            
                        }
                    }
                    .navigationTitle("Pills Memo")
                    .toolbar {
                        ToolbarItem {
                            Button {
                                let drug = Drug(
                                    color: ColorOptions.random().rgbaColor,
                                    title: "",
                                    drugType: .Pills,
                                    quantity: "",
                                    frequency: .daily,
                                    duration: .oneDay,
                                    doses: [],
                                    notes: ""
                                )
                                context.insert(drug)
                                newDrugID = drug.id
                                
                                isAddingNewDrug = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $isAddingNewDrug, onDismiss: {
                        // If the user dismisses without saving and the title is still empty, delete the drug
                        if let id = newDrugID,
                           let drugToDelete = drugs.first(where: { $0.id == id }),
                           drugToDelete.title.isEmpty {
                            context.delete(drugToDelete)
                        }
                        newDrugID = nil
                    }) {
                        NavigationStack {
                            // here I want to show DrugEditorView
                            if let id = newDrugID, let drug = drugs.first(where: { $0.id == id }) {
                                
                                DrugDetailView(drug: drug, initialTab: 1)
                                    .navigationTitle("New Medication")
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Button("Cancel") {
                                                context.delete(drug)
                                                isAddingNewDrug = false
                                            }
                                        }
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button {
                                                //add new drug to drugs list
                                                
                                                isAddingNewDrug = false
                                            } label: {
                                                Text("Add" )
                                            }
                                            .disabled(drug.title.isEmpty)
                                        }
                                    }
                            }
                        }
                        
                    }
                }
                
                if drugs.isEmpty {
                    EmptyState(imageName: "empty-drugs", message: "Looks like your medication list is empty")
                }
            }
        } detail: {
            ZStack {
                if let selectedDrug = selection {
                    DrugDetailView(drug: selectedDrug)
                } else {
                    Text("Select a Drug")
                    .foregroundStyle(.secondary)
                }
            }
        }

        
    }
}

#Preview {
    DrugsListView()
}
