//
//  EstimatedTimeIcon.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 10/05/25.
//

import SwiftUI

struct EstimatedTimeIcon: View {
    let icon: String
    let time: Int
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            Image(systemName: icon)
                .resizable()
                .foregroundStyle(.primary)
                
                .frame(width: 16, height: 16)
                .padding([.bottom, .trailing], time > 99 ? 12 : 11)
            Text("\(time)")
                .font(.caption2)
        }
    }
}

#Preview {
    EstimatedTimeIcon(icon: "figure.walk", time: 100)
    EstimatedTimeIcon(icon: "figure.walk", time: 99)
    EstimatedTimeIcon(icon: "arrow.trianglehead.branch", time: 10)
}
