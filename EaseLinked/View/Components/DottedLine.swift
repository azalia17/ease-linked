//
//  DottedLine.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 12/05/25.
//

import SwiftUI

struct DottedLine: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 40)) // Change 300 to desired width
        }
        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [1, 12])) // [dotLength, gapLength]
        .foregroundColor(Color(.systemGray3))
        .frame(height: 40)
    }
}

#Preview {
    DottedLine()
}
