//
//  ThumbnailCardView.swift
//  FocalGrid
//
//  Created by DIMAS DAFFA ERNANDA on 17/06/26.
//

import SwiftUI

struct ThumbnailCardView: View {
    let type: CompositionType
    var onLearnTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(LocalizedStringKey(type.cardSubtitle))
                .font(.title3)
                .bold()
            
            Image(type.gridImageName)
                .resizable()
                .scaledToFit()
            
            
            Text(type.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            
            Button(action: onLearnTapped) {
                Text("Learn")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.themePrimary)
                    .padding(.vertical,4)
                    .padding(.horizontal,28)
                    .background(.black)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 32)
        .background(type.themeColor)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ThumbnailCardView(type: .ruleOfThirds) {
        print("Learn Tapped")
    }
}
