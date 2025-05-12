//
//  ImageStack.swift
//  BSDLink
//
//  Created by Azalia Amanda on 01/04/25.
//

/** Complete **/

import SwiftUI

struct ImageStack: View {
    
    var isSmall: Bool = false
    @State private var isFullScreen: Bool = false
    
    
    var images: [String] = []
    
    var body: some View {
        ZStack {
            if !images.isEmpty {
                if(images.count > 1) {
                    Image(images[1])
                        .resizable()
                        .frame(width: isSmall ? 30 : 72, height: isSmall ? 30 : 72)
                        .clipShape(RoundedRectangle(cornerRadius: isSmall ? 6 : 8, style: .continuous))
                        .offset(x: isSmall ? 4 : 8, y: isSmall ? 4 : 8)
                }
                Image(images[0])
                    .resizable()
                    .frame(width: isSmall ? 30 : 72, height: isSmall ? 30 : 72)
                    .clipShape(RoundedRectangle(cornerRadius: isSmall ? 6 : 8, style: .continuous))
                    .overlay(
                            RoundedRectangle(cornerRadius: isSmall ? 6 : 8, style: .continuous)
                                .stroke(.white, lineWidth: 1)
                        )

            }
            else {
                Image(systemName: "photo")
                    .resizable()
                    .padding(12)
                    .frame(width: isSmall ? 30 : 72, height: isSmall ? 30 : 72, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: isSmall ? 6 : 8, style: .continuous))
                    .offset(x: isSmall ? 4 : 8, y: isSmall ? 4 : 8)
            }
        }
        .onTapGesture {
            isFullScreen = true
        }
        .fullScreenCover(isPresented: $isFullScreen) {
            ImageCarousel(images: images) {
                isFullScreen = false
            }
        }
    }
}

#Preview {
    ImageStack(
        images: ["Intermoda_1"
                ,
            "Intermoda_2"
                 ]
    )
    ImageStack(
        isSmall: true,
        images: ["Intermoda_1"
                ,
            "Intermoda_2"
                 ]
    )
}
