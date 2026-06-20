//
//  MechanicDetailViewModel.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 20/06/26.
//

import SwiftUI

@Observable
final class MechanicDetailViewModel {
    
    // MARK: - Properties
    
    let mechanics: [GridMechanic]
    let themeColor: Color
    let compositionTitle: String
    var currentPageID: String?
    
    // MARK: - Init
    
    init(mechanics: [GridMechanic], startingMechanicIndex: Int, themeColor: Color, compositionTitle: String) {
        self.mechanics = mechanics
        self.themeColor = themeColor
        self.compositionTitle = compositionTitle
        self.currentPageID = mechanics[startingMechanicIndex].id
    }
    
    // MARK: - Computed Properties
    
    var currentIndex: Int {
        guard let id = currentPageID else { return 0 }
        return mechanics.firstIndex(where: { $0.id == id }) ?? 0
    }
    
    var currentTitle: String {
        mechanics[currentIndex].title
    }
    
    var currentStep: Int {
        currentIndex + 1
    }
    
    var totalSteps: Int {
        mechanics.count
    }
}
