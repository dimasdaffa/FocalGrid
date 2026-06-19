//
//  DetailCardView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 16/06/26.
//

import SwiftUI

struct DetailCardView: View {
    let type: CompositionType

    private var composition: Composition? {
        Composition.mockCompositions.first { $0.type == type }
    }

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
                                    .foregroundColor(.primary)
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
                                    .foregroundColor(.primary)
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
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    Text("Grid Mechanics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.top, 28)

                    VStack(spacing: 0) {
                        ForEach(Array(composition.mechanics.enumerated()), id: \.element.id) { index, mechanic in
                            MechanicRowView(
                                title: mechanic.title,
                                subtitle: mechanic.readingTime,
                                index: index + 1,
                                type: type
                            )
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
                        // TODO: Navigate to reading view
                    },
                    onCameraTapped: {
                        // TODO: Open camera view
                    }
                )
                .padding(.horizontal,16)
            }
        }
    }
}


#Preview {
    NavigationStack {
        DetailCardView(type: .ruleOfThirds)
    }
}
