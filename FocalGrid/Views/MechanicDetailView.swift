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
                    mechanicPageContainer(mechanic)
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if viewModel.currentIndex > 0 {
                    Button(action: {
                        viewModel.goToPreviousPage()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }

    // MARK: - Page Container

    @ViewBuilder
    private func mechanicPageContainer(_ mechanic: GridMechanic) -> some View {
        if mechanic.imageAsset != nil {
            // Full-size page: opening image or photographic breakdown
            mechanicPage(mechanic)
                .containerRelativeFrame(.vertical, alignment: .topLeading)
                .clipped()
        } else {
            // Text-only page: shorter frame with bottom spill
            mechanicPage(mechanic)
                .containerRelativeFrame(.vertical, alignment: .topLeading) { height, _ in
                    height - 80
                }
                .mask(
                    VStack(spacing: 0) {
                        Color.white
                        LinearGradient(
                            colors: [.white, .white.opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                    }
                )
        }
    }

    // MARK: - Page Content

    @ViewBuilder
    private func mechanicPage(_ mechanic: GridMechanic) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                switch mechanic.layoutStyle {
                case .imageBottom:
                    headlineView(mechanic)
                    bodyView(mechanic)
                    Spacer(minLength: 16)
                    imageView(mechanic)
                    
                case .imageTop:
                    imageView(mechanic)
                        .padding(.top, 36)
                    headlineView(mechanic, topPadding: 16)
                    bodyView(mechanic)
                    Spacer(minLength: 16)
                    
                case .textCentered:
                    Spacer(minLength: 40)
                    headlineView(mechanic)
                    bodyView(mechanic)
                    Spacer(minLength: 60)
                }
            }
            .padding(.horizontal, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    // MARK: - View Builders

    @ViewBuilder
    private func headlineView(_ mechanic: GridMechanic, topPadding: CGFloat = 36) -> some View {
        Text(LocalizedStringKey(mechanic.headline))
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.white)
            .lineSpacing(6)
            .padding(.top, topPadding)
            .padding(.bottom, 24)
    }

    @ViewBuilder
    private func bodyView(_ mechanic: GridMechanic) -> some View {
        Text(LocalizedStringKey(mechanic.bodyContent))
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.white.opacity(0.82))
            .lineSpacing(7)
            .padding(.bottom, 24)
    }

    @ViewBuilder
    private func imageView(_ mechanic: GridMechanic) -> some View {
        if let imageAsset = mechanic.imageAsset {
            Image(imageAsset)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()

            Text("by: dimas daffa")
                .font(.system(size: 12, weight: .regular))
                .italic()
                .foregroundColor(.white.opacity(0.35))
                .padding(.top, 6)
                .padding(.bottom, 24)
        }
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
