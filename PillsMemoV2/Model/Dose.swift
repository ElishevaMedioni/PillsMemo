//
//  Dose.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import Foundation
import SwiftData

@Model
class Dose {
    var id = UUID()
    var time: Date
    var timeTaken: Date?
    
    init(id: UUID = UUID(), time: Date, timeTaken: Date? = nil) {
        self.id = id
        self.time = time
        self.timeTaken = timeTaken
    }
}
