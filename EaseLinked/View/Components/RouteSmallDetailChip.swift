//
//  RouteSmallDetailChip.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct RouteSmallDetailChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(.gray)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    RouteSmallDetailChip(icon: "arrow.trianglehead.branch", text: "Transit at The Breeze")
    RouteSmallDetailChip(icon: "figure.walk", text: "1 km")
    RouteSmallDetailChip(icon: "plusminus", text: "40 min")
}
