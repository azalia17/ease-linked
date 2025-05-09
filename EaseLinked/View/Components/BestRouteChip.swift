//
//  BestRouteChip.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct BestRouteChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 12, height: 11)

            Text(text)
                .padding(.leading, 8)
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundStyle(.blue)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
    }
}

#Preview {
    BestRouteChip(icon: "bus", text: "Earliest Bus ETA")
}
