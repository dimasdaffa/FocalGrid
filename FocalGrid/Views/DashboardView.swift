//
//  DashboardView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 16/06/26.
//

import SwiftUI

struct DashboardView: View {
    @State private var path: [CompositionType] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(CompositionType.allCases, id: \.self) { type in
                        ThumbnailCardView(type: type) {
                            path.append(type)
                        }
                    }
                }
                .padding(.vertical)
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    HStack {
                        Text("FocalGrid")
                            .font(.system(.largeTitle, weight: .bold))
                            .foregroundColor(Color.themePrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    .background(Color(uiColor: .systemBackground))
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: CompositionType.self) { type in
                DetailCardView(type: type)
            }
        }
    }
}

#Preview {
    DashboardView()
}
