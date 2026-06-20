//
//  DetailCardViewModel.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 20/06/26.
//

import SwiftUI

@Observable
final class DetailCardViewModel {
    
    // MARK: - Properties
    
    let type: CompositionType
    var selectedMechanicRoute: MechanicRoute?
    
    // MARK: - Computed Properties
    
    var composition: Composition? {
        Composition.mockCompositions.first { $0.type == type }
    }
    
    var firstMechanic: GridMechanic? {
        composition?.mechanics.first
    }
    
    var firstMechanicTitle: String {
        firstMechanic?.title ?? ""
    }
    
    var mechanicCount: Int {
        composition?.mechanics.count ?? 0
    }
    
    // MARK: - Init
    
    init(type: CompositionType) {
        self.type = type
    }
    
    // MARK: - Actions
    
    func selectMechanic(id: String) {
        selectedMechanicRoute = MechanicRoute(
            mechanicId: id,
            compositionType: type
        )
    }
    
    func selectFirstMechanic() {
        guard let firstMechanic = firstMechanic else { return }
        selectMechanic(id: firstMechanic.id)
    }
    
    /// Resolves a route into the data needed by MechanicDetailView.
    static func resolveMechanicRoute(_ route: MechanicRoute) -> (mechanics: [GridMechanic], startIndex: Int, themeColor: Color, title: String)? {
        guard let composition = Composition.mockCompositions.first(where: { $0.type == route.compositionType }),
              let mechanicIndex = composition.mechanics.firstIndex(where: { $0.id == route.mechanicId })
        else { return nil }
        
        return (
            mechanics: composition.mechanics,
            startIndex: mechanicIndex,
            themeColor: route.compositionType.themeColor,
            title: route.compositionType.title
        )
    }
}
