//
//  DrugType.swift
//  PillsMemoV2
//
//  Created by Elisheva Medioni on 15/05/2024.
//

import Foundation

enum DrugType: String, Codable, CaseIterable {
    case Pills, Drop, Injection, Vitamins
    
    var symbol: String {
        switch self {
        case .Pills: return "pills"
        case .Drop: return "drop"
        case .Injection: return "syringe"
        case .Vitamins: return "pill.circle"
        }
    }
    
   
}
