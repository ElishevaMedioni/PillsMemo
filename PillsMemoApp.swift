import SwiftUI

@main
struct PillsMemoApp: App {
    @StateObject private var drugData = DrugData()
    var body: some Scene {
        
        WindowGroup {
            DrugList(drugData: drugData)
        }
    }
}
