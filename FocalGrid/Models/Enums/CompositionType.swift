//
//  CompositionType.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 17/06/26.
//

import Foundation
import SwiftUI

enum CompositionType: String, CaseIterable, Codable {
    case ruleOfThirds = "rule_of_thirds"
    case goldenRatio = "golden_ratio"
    case diagonalLines = "diagonal_lines"
    case leadingLines = "leading_lines"
    
    var title: String {
        switch self {
        case .ruleOfThirds: return "Rule of Thirds"
        case .goldenRatio: return "Golden Ratio"
        case .diagonalLines: return "Diagonal Lines"
        case .leadingLines: return "Leading Lines"
        }
    }
    
    var cardSubtitle: String {
        switch self {
        case .ruleOfThirds: return "Frame your world with perfect *balance*."
        case .goldenRatio: return "Discover nature's *divine proportion*."
        case .diagonalLines: return "Inject *dynamic* energy into every shot."
        case .leadingLines: return "Guide the *viewer's eyes* exactly where you want."
        }
    }
    
    var gridImageName: String {
        switch self {
        case .ruleOfThirds: return "grid_rule_of_thirds"
        case .goldenRatio: return "grid_golden_ratio"
        case .diagonalLines: return "grid_diagonal_lines"
        case .leadingLines: return "grid_leading_lines"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .ruleOfThirds: return .themeMaple
        case .goldenRatio: return .themeCoast
        case .diagonalLines: return .themeBlue
        case .leadingLines: return .themeClay
        }
    }
}
