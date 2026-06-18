//
//  DetailCardView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 16/06/26.
//

import SwiftUI

struct DetailCardView: View {
    let type: CompositionType
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image(type.gridImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(Color.themeShadow.opacity(0.05))
                    .cornerRadius(12)
                    
                Text(LocalizedStringKey(type.cardSubtitle))
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
                
                // Content section placeholder or info text
                VStack(alignment: .leading, spacing: 12) {
                    Text("About \(type.title)")
                        .font(.title2)
                        .bold()
                    
                    Text("This composition technique helps you guide the viewer's focus and create balanced, visually appealing photographs. Practice applying this grid layout in your camera frame to enhance your visual storytelling.")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 4)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(type.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DetailCardView(type: .ruleOfThirds)
    }
}
