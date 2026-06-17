//
//  CompositionType.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 17/06/26.
//

import Foundation

enum CompositionType: String, CaseIterable, Codable {
    case ruleOfThirds = "rule_of_thirds"
    
    var title: String {
        switch self {
        case .ruleOfThirds: return "Rule of Thirds"
        }
    }
    
    var assetColorName: String {
        switch self {
        case .ruleOfThirds: return "themeMaple" 
        }
    }
}
