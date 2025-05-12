//
//  DottedLine.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 12/05/25.
//

import SwiftUI

struct DottedLine: View {
    var height: CGFloat = 40
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height)) 
        }
        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [1, 12]))
        .foregroundColor(Color(.systemGray3))
        .frame(width: 4, height: height)
    }
}

#Preview {
    DottedLine()
}
