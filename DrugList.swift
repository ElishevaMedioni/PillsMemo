import SwiftUI

struct DrugList: View {
    
    @ObservedObject var drugData: DrugData
    
    @State private var isAddingNewDrug = false
    @State private var newDrug = Drug()
    
    @State private var selection: Drug?
    
    var body: some View {
        
        NavigationSplitView {
            
            List(selection: $selection) {
                ForEach(Period.allCases) { period in
                    
                    Section(content: {
                        
                        ForEach(drugData.sortedDrugs(period: period)) { $drug in
                            
                            DrugRow(drug: drug)
                                .onAppear {
                                    drug.calculateDoses() // Calculate doses whenever a DrugRow appears
                                }
                                .tag(drug)
                            
                                .swipeActions {
                                    Button(role: .destructive) {
                                        selection = nil
                                        drugData.remove(drug)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            
                        }
                    }, header: {
                        Text(period.name)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    })
                    .disabled(drugData.sortedDrugs(period: period).isEmpty)
                }
            }
            .navigationTitle("Pills Memo")
            .toolbar {
                ToolbarItem {
                    Button {
                        newDrug = Drug()
                        isAddingNewDrug = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingNewDrug) {
                NavigationStack {
                    DrugEditor(drug: $newDrug, isNew: true)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isAddingNewDrug = false
                                }
                            }
                            ToolbarItem {
                                Button {
                                    newDrug.calculateDoses()
                                    drugData.add(newDrug)
                                    isAddingNewDrug = false
                                } label: {
                                    Text("Add" )
                                }
                                .disabled(newDrug.title.isEmpty)
                            }
                        }
                }
            }
            
        } detail: {
            ZStack {
                if let drug = selection, let drugBinding = drugData.getBindingToDrug(drug) {
                    DrugEditor(drug: drugBinding)
                } else {
                    Text("Select a Drug")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct DrugList_Previews: PreviewProvider {
    static var previews: some View {
        DrugList(drugData: DrugData())
    }
}
