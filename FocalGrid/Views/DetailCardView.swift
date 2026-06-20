//
//  DetailCardView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 16/06/26.
//

import SwiftUI

struct DetailCardView: View {
    @State private var viewModel: DetailCardViewModel

    init(type: CompositionType) {
        _viewModel = State(initialValue: DetailCardViewModel(type: type))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                Image(viewModel.type.gridImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(viewModel.type.themeColor)
                    .padding(.horizontal, 20)

                if let composition = viewModel.composition {
                    statsSection(composition)
                    descriptionSection(composition)
                    mechanicsSection(composition)
                }
            }
        }
        .navigationTitle(viewModel.type.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            ctaSection
        }
        .navigationDestination(item: $viewModel.selectedMechanicRoute) { route in
            if let resolved = DetailCardViewModel.resolveMechanicRoute(route) {
                MechanicDetailView(
                    mechanics: resolved.mechanics,
                    startingMechanicIndex: resolved.startIndex,
                    themeColor: resolved.themeColor,
                    compositionTitle: resolved.title
                )
            }
        }
    }

    // MARK: - Stats Section

    @ViewBuilder
    private func statsSection(_ composition: Composition) -> some View {
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
    }

    // MARK: - Description Section

    @ViewBuilder
    private func descriptionSection(_ composition: Composition) -> some View {
        Text(composition.description)
            .font(.body)
            .foregroundColor(Color.themePrimary)
            .padding(.horizontal, 20)
            .padding(.top, 20)
    }

    // MARK: - Mechanics Section

    @ViewBuilder
    private func mechanicsSection(_ composition: Composition) -> some View {
        Text("Grid Mechanics")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color.themePrimary)
            .padding(.horizontal, 20)
            .padding(.top, 28)

        VStack(spacing: 0) {
            ForEach(Array(composition.mechanics.enumerated()), id: \.element.id) { index, mechanic in
                Button {
                    viewModel.selectMechanic(id: mechanic.id)
                } label: {
                    MechanicRowView(
                        title: mechanic.title,
                        subtitle: mechanic.readingTime,
                        index: index + 1,
                        type: viewModel.type
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
            type: viewModel.type
        )
        .padding(.horizontal, 20)
    }

    // MARK: - CTA Section

    @ViewBuilder
    private var ctaSection: some View {
        if let composition = viewModel.composition,
           let firstMechanic = composition.mechanics.first {
            DetailCTAView(
                index: 1,
                title: firstMechanic.title,
                themeColor: viewModel.type.themeColor,
                onStartReadingTapped: {
                    viewModel.selectFirstMechanic()
                },
                onCameraTapped: {
                    // TODO: Open camera view
                }
            )
            .padding(.horizontal, 16)
        }
    }
}


#Preview {
    NavigationStack {
        DetailCardView(type: .ruleOfThirds)
    }
}
