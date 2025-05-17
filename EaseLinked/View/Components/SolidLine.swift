//
//  SolidLine.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import SwiftUI

struct SolidLine: View {
    let height: Double
    let color: Color
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
        }
        .stroke(style: StrokeStyle(lineWidth: 5))
        .foregroundColor(color)
        .frame(width: 5, height: max(0, height))
    }
}

#Preview {
    VStack(spacing: 0) {
        SolidLine(height: 40, color: .pink)
            .padding(.horizontal, 20)
        SolidLine(height: 40, color: .yellow)
            .padding(.horizontal, 20)
            .background(.green)
    }
}
