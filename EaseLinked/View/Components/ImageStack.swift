//
//  ImageStack.swift
//  BSDLink
//
//  Created by Azalia Amanda on 01/04/25.
//

/** Complete **/

import SwiftUI

struct ImageStack: View {
    
    @State private var isFullScreen: Bool = false
    
    var images: [String] = []
    
    var body: some View {
        ZStack {
            if !images.isEmpty {
                if(images.count > 1) {
                    Image(images[1])
                        .resizable()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .offset(x: 8, y: 8)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .padding(12)
                        .frame(width: 72, height: 72, alignment: .center)
                        .foregroundColor(.white.opacity(0.7))
                        .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .offset(x: 8, y: 8)
                }
                Image(images[0])
                    .resizable()
                    .frame(width: 72, height: 72)
                    .border(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 7, y: 8)
            }
            else {
                Image(systemName: "photo")
                    .resizable()
                    .padding(12)
                    .frame(width: 72, height: 72, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .offset(x: 8, y: 8)
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

//#Preview {
//    ImageStack(
//        images: ["Intermoda_1"]
//        //        ,
//        //        secondImage: "Intermoda_2"
//    )
//}
