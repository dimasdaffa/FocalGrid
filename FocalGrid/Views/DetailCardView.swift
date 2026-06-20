//
//  DetailCardView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 16/06/26.
//

import SwiftUI

/// A route object for navigating to a specific mechanic within a composition.
struct MechanicRoute: Hashable {
    let mechanicId: String
    let compositionType: CompositionType
}

struct DetailCardView: View {
    let type: CompositionType

    private var composition: Composition? {
        Composition.mockCompositions.first { $0.type == type }
    }

    @State private var selectedMechanicRoute: MechanicRoute?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                Image(type.gridImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(type.themeColor)
                    .padding(.horizontal, 20)

                if let composition = composition {
                    HStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Key Ideas")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(composition.keyIdeasCount)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.themePrimary)
                            }
                            Spacer()
                            Image(systemName: "text.book.closed.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .padding(12)
                        .background(Color(uiColor: .secondarySystemBackground))

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Time / Idea")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(composition.durationText)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.themePrimary)
                            }
                            Spacer()
                            Image(systemName: "clock.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .padding(12)
                        .background(Color(uiColor: .secondarySystemBackground))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    Text(composition.description)
                        .font(.body)
                        .foregroundColor(Color.themePrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    Text("Grid Mechanics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.themePrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 28)

                    VStack(spacing: 0) {
                        ForEach(Array(composition.mechanics.enumerated()), id: \.element.id) { index, mechanic in
                            Button {
                                selectedMechanicRoute = MechanicRoute(
                                    mechanicId: mechanic.id,
                                    compositionType: type
                                )
                            } label: {
                                MechanicRowView(
                                    title: mechanic.title,
                                    subtitle: mechanic.readingTime,
                                    index: index + 1,
                                    type: type
                                )
                            }
                            .buttonStyle(.plain)

                            if index < composition.mechanics.count - 1 {
                                Divider()
                                    .padding(.leading, 56)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    Divider()
                        .padding(.horizontal, 20)

                    MechanicRowView(
                        title: "Photographic Breakdown",
                        subtitle: "1 min",
                        index: composition.mechanics.count + 1,
                        type: type
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationTitle(type.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            if let composition = composition,
               let firstMechanic = composition.mechanics.first {
                DetailCTAView(
                    index: 1,
                    title: firstMechanic.title,
                    themeColor: type.themeColor,
                    onStartReadingTapped: {
                        selectedMechanicRoute = MechanicRoute(
                            mechanicId: firstMechanic.id,
                            compositionType: type
                        )
                    },
                    onCameraTapped: {
                        // TODO: Open camera view
                    }
                )
                .padding(.horizontal, 16)
            }
        }
        .navigationDestination(item: $selectedMechanicRoute) { route in
            if let composition = Composition.mockCompositions.first(where: { $0.type == route.compositionType }),
               let mechanicIndex = composition.mechanics.firstIndex(where: { $0.id == route.mechanicId }) {
                MechanicDetailView(
                    mechanic: composition.mechanics[mechanicIndex],
                    mechanicIndex: mechanicIndex + 1,
                    // +1 for Photographic Breakdown
                    totalMechanics: composition.mechanics.count + 1,
                    themeColor: route.compositionType.themeColor,
                    compositionTitle: route.compositionType.title
                )
            }
        }
    }
}


#Preview {
    NavigationStack {
        DetailCardView(type: .ruleOfThirds)
    }
}
