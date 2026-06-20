//
//  MechanicDetailView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 20/06/26.
//

import SwiftUI

struct MechanicDetailView: View {
    let mechanic: GridMechanic
    let mechanicIndex: Int
    let totalMechanics: Int
    let themeColor: Color
    let compositionTitle: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        // MARK: - Scrollable Theory Content
        ScrollView(showsIndicators: false) {
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
                    .padding(.bottom, 32)

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
                        .padding(.bottom, 48)
                } else {
                    Spacer()
                        .frame(height: 48)
                }
            }
            .padding(.horizontal, 24)
        }
        .safeAreaInset(edge: .top) {
            ProgressBarView(
                currentStep: mechanicIndex,
                totalSteps: totalMechanics,
                themeColor: themeColor
            )
        }
        .background(Color.themeShadow.ignoresSafeArea())
        .navigationTitle(mechanic.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MechanicDetailView(
            mechanic: Composition.mockCompositions[0].mechanics[0],
            mechanicIndex: 1,
            totalMechanics: 4,
            themeColor: .themeMaple,
            compositionTitle: "Rule of Thirds"
        )
    }
}
