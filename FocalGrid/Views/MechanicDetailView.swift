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
            // VStack (not Lazy) so the current page's spill overlay reliably draws
            // on top of the next page's peek via zIndex. Page counts are small.
            VStack(spacing: 0) {
                ForEach(viewModel.mechanics, id: \.id) { mechanic in
                    mechanicPageContainer(mechanic)
                        .id(mechanic.id)
                        // Current page sits above its neighbour so its bottom spill
                        // can dim the peeking next page.
                        .zIndex(mechanic.id == viewModel.currentPageID ? 1 : 0)
                }
            }
            .scrollTargetLayout()
        }
        // .always limits each swipe to a single section (Deepstash-style paging);
        // a fast flick can no longer skip from the first section to the last.
        // Strict one-by-one paging. Every card fits one screen (the long breakdown lives
        // on its own screen now), so a single global behavior is all that's needed.
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
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
            // Text-only page: the shorter frame lets the next page peek through at the
            // bottom. The gradient fades this page's tail and the peek into black
            // (Deepstash-style spill). Only the current page draws it, and because it
            // lives on the container it scrolls with the content — incoming pages are
            // never dimmed by a fixed overlay.
            mechanicPage(mechanic)
                .containerRelativeFrame(.vertical, alignment: .topLeading) { height, _ in
                    height - 80
                }
                .overlay(alignment: .bottom) {
                    if mechanic.id == viewModel.currentPageID {
                        // Flat 50% scrim over the next-page peek — no gradient. Sits in
                        // the empty area below the current text, so it only dims the
                        // peeking content. Offset + ignoresSafeArea carry it all the way
                        // to the physical bottom edge (through the home-indicator inset).
                        Color.black.opacity(0.5)
                            .frame(height: 180)
                            .offset(y: 120)
                            .allowsHitTesting(false)
                            .ignoresSafeArea(edges: .bottom)
                    }
                }
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
        // ponytail: inner scroll on only for the last page (the long breakdown). Middle
        // cards are one screen, so their inner scroll would just steal flicks from the
        // pager. On the breakdown, drag to scroll — a fast flick is eaten by the pager.
        .scrollDisabled(mechanic.id != viewModel.mechanics.last?.id)
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
