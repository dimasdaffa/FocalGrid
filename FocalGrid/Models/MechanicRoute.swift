//
//  MechanicRoute.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 20/06/26.
//

import Foundation

/// A route object for navigating to a specific mechanic within a composition.
struct MechanicRoute: Hashable {
    let mechanicId: String
    let compositionType: CompositionType
}
