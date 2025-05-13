//
//  Chip.swift
//  BSDLink
//
//  Created by Azalia Amanda on 19/03/25.
//

/** Complete **/

import SwiftUI

struct Chip: View {
    var text: String
    var color: Color = Color.blue
    var textColor: Color = Color.white.opacity(0.8)
    
    var body: some View {
        VStack {
            Text(text)
                .font(.subheadline)
                .bold()
                .foregroundColor(textColor)
        }
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 4)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

#Preview {
    Chip(text: "Hello")
}
