//
//  CompositionModel.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 18/06/26.
//

import Foundation

struct Composition: Identifiable, Codable {
    var id: String { type.rawValue }
    let type: CompositionType
    let description: String
    let keyIdeasCount: Int
    let durationText: String
    let mechanics: [GridMechanic]
    let breakdown: PhotographicBreakdown
}

// MARK: - Sub-Models

struct GridMechanic: Identifiable, Codable {
    let id: String
    let title: String
    let readingTime: String
    let headline: String
    let bodyContent: String
    let imageAsset: String?
}

struct PhotographicBreakdown: Codable {
    let headline: String
    let imageAsset: String
    let photographer: String
    let layers: [CompositionLayer]
}

struct CompositionLayer: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
}
