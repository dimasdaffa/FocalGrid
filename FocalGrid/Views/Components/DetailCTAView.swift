//
//  DetailCTAView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 18/06/26.
//

import SwiftUI

struct DetailCTAView: View {
    let mechanicNumber: Int
    let mechanicTitle: String
    let themeColor: Color
    let onReadTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("#\(mechanicNumber) \(mechanicTitle.uppercased())")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.themePrimary)
                    .lineLimit(1)

                Button(action: onReadTapped) {
                    Text("Start Reading")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(red: 0x11/255, green: 0x11/255, blue: 0x11/255))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.themePrimary)
                }
            }

            // Right side: Camera icon
            ZStack {
                Rectangle()
                    .fill(themeColor)
                    .frame(width: 56, height: 56)

                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(Color.themePrimary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(red: 0x2D/255, green: 0x2D/255, blue: 0x30/255))
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1D/255).opacity(0.95), lineWidth: 1)
        )
    }
}

#Preview {
    DetailCTAView(
        mechanicNumber: 1,
        mechanicTitle: "The 3x3 Grid Matrix",
        themeColor: .themeMaple,
        onReadTapped: {}
    )
    .preferredColorScheme(.dark)
}
