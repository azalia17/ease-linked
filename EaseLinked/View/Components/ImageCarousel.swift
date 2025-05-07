//
//  ImageCarousel.swift
//  BSDLink
//
//  Created by Azalia Amanda on 03/04/25.
//

/** Complete **/

import SwiftUI

struct ImageCarousel: View {
    let images: [String]
    @State private var index: Int = 0 // Always starts from first image
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    var onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onClose() // Tap outside to close
                }
            
            TabView(selection: $index) {
                ForEach(images.indices, id: \.self) { i in
                    Image(images[i])
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(1.0, lastScale * value)
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            Button("Close") {
                onClose()
            }
            .padding(.trailing)
            .foregroundColor(.white)
        }
    }
}
