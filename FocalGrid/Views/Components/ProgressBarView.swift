//
//  ProgressBarView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 20/06/26.
//

import SwiftUI

struct ProgressBarView: View {
    let currentStep: Int
    let totalSteps: Int
    let themeColor: Color

    private var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(currentStep) / Double(totalSteps)
    }

    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(.linear)
            .tint(themeColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBarView(currentStep: 1, totalSteps: 4, themeColor: .themeMaple)
        ProgressBarView(currentStep: 2, totalSteps: 4, themeColor: .themeCoast)
        ProgressBarView(currentStep: 3, totalSteps: 4, themeColor: .themeBlue)
        ProgressBarView(currentStep: 4, totalSteps: 4, themeColor: .themeClay)
    }
    .padding()
    .background(Color.themeShadow)
}
