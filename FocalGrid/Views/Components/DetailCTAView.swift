//
//  DetailCTAView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 18/06/26.
//

import SwiftUI

struct DetailCTAView: View {
    let index: Int
    let title: String
    let themeColor: Color
    
    var onStartReadingTapped: () -> Void
    var onCameraTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("#\(index) \(title.uppercased())")
                    .font(.headline.weight(.medium))
                    .foregroundColor(Color.themePrimary)
                    .lineLimit(1)
                
                Button(action: onStartReadingTapped) {
                    Text("Read Theory")
                        .font(.title2.weight(.medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 2)
                        .background(Color.themePrimary)
                }
                .background(Color.black.offset(y: 6))
                .padding(.bottom, 4)
            }
            
            Button(action: onCameraTapped) {
                ZStack {
                    themeColor
                    
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 38, weight: .medium))
                        .foregroundColor(Color.themePrimary)
                }
                .frame(width: 70)
                .frame(maxHeight: .infinity)
            }
            .background(Color.black.offset(y: 6))
            .padding(.bottom, 4)
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
        .padding(.horizontal, 16)
        .background(Color.themeHardShadow.opacity(0.55), ignoresSafeAreaEdges: [])
        .overlay(
            Rectangle()
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.52)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    ZStack {
        Color.themeShadow.edgesIgnoringSafeArea(.all)
        
        DetailCTAView(
            index: 1,
            title: "The 3x3 Grid Matrix",
            themeColor: .themeMaple
        ) {
        } onCameraTapped: {
        }
        .padding(.horizontal, 24)
    }
}
