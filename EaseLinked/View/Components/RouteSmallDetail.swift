//
//  RouteSmallDetail.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct RouteSmallDetail: View {
    let walkingDistance: Int
    let estimatedTravelTime: Int
    
    var body: some View {
        HStack {
            RouteSmallDetailChip(icon: "figure.walk", text: "\(walkingDistance) km")
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 4, height: 4)
                .foregroundStyle(.gray.opacity(0.4))
            RouteSmallDetailChip(icon: "plusminus", text: "\(estimatedTravelTime) min")
        }
    }
}

#Preview {
    RouteSmallDetail(walkingDistance: 10, estimatedTravelTime: 10)
}
