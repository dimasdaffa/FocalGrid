//
//  MechanicRowView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 19/06/26.
//

import SwiftUI

struct MechanicRowView: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .stroke(Color.secondary.opacity(0.4), lineWidth: 1.5)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    MechanicRowView(
        title: "Photographic Breakdown",
        subtitle: "1 min"
    )
}
