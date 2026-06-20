//
//  MechanicDetailView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 20/06/26.
//

import SwiftUI

struct MechanicDetailView: View {
    @State private var viewModel: MechanicDetailViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(mechanics: [GridMechanic], startingMechanicIndex: Int, themeColor: Color, compositionTitle: String) {
        _viewModel = State(initialValue: MechanicDetailViewModel(
            mechanics: mechanics,
            startingMechanicIndex: startingMechanicIndex,
            themeColor: themeColor,
            compositionTitle: compositionTitle
        ))
    }

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.mechanics, id: \.id) { mechanic in
                    mechanicPage(mechanic)
                        .containerRelativeFrame(.vertical, alignment: .topLeading)
                        .clipped()
                        .id(mechanic.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $viewModel.currentPageID)
        .safeAreaInset(edge: .top) {
            ProgressBarView(
                currentStep: viewModel.currentStep,
                totalSteps: viewModel.totalSteps,
                themeColor: viewModel.themeColor
            )
            .background(.black)
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle(viewModel.currentTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
            }
        }
    }

    // MARK: - Page Content

    @ViewBuilder
    private func mechanicPage(_ mechanic: GridMechanic) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Headline
            Text(LocalizedStringKey(mechanic.headline))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
                .lineSpacing(6)
                .padding(.top, 36)
                .padding(.bottom, 24)

            // Body content with markdown
            Text(LocalizedStringKey(mechanic.bodyContent))
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.82))
                .lineSpacing(7)
                .padding(.bottom, 24)

            Spacer(minLength: 16)

            // Image asset (if exists)
            if let imageAsset = mechanic.imageAsset {
                Image(imageAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipped()

                // Photographer credit
                Text("by: dimas daffa")
                    .font(.system(size: 12, weight: .regular))
                    .italic()
                    .foregroundColor(.white.opacity(0.35))
                    .padding(.top, 6)
                    .padding(.bottom, 24)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MechanicDetailView(
            mechanics: Composition.mockCompositions[0].mechanics,
            startingMechanicIndex: 0,
            themeColor: .themeMaple,
            compositionTitle: "Rule of Thirds"
        )
    }
}
