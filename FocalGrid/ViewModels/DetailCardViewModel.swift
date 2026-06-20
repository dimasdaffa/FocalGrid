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
        allMechanics.first
    }
    
    var firstMechanicTitle: String {
        firstMechanic?.title ?? ""
    }
    
    var mechanicCount: Int {
        allMechanics.count
    }
    
    var allMechanics: [GridMechanic] {
        guard let composition = composition else { return [] }
        var list = composition.mechanics
        
        // Convert breakdown into a GridMechanic
        let breakdownBody = composition.breakdown.layers.map { layer in
            "• **\(layer.title):** \(layer.description)"
        }.joined(separator: "\n\n")
        
        let breakdownMechanic = GridMechanic(
            id: "\(composition.type.rawValue)_breakdown",
            title: "Photographic Breakdown",
            readingTime: "1 min",
            headline: composition.breakdown.headline,
            bodyContent: breakdownBody,
            imageAsset: composition.breakdown.imageAsset,
            layoutStyle: .imageTop
        )
        
        list.append(breakdownMechanic)
        return list
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
        let tempViewModel = DetailCardViewModel(type: route.compositionType)
        let mechanics = tempViewModel.allMechanics
        
        guard let mechanicIndex = mechanics.firstIndex(where: { $0.id == route.mechanicId }) else { return nil }
        
        return (
            mechanics: mechanics,
            startIndex: mechanicIndex,
            themeColor: route.compositionType.themeColor,
            title: route.compositionType.title
        )
    }
}
