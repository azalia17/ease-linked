//
//  PathStart.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 12/05/25.
//

import SwiftUI

struct PathStart: View {
    let startLocation: String
    let walkingDistance: Int
    let walkingTime: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .foregroundStyle(Color(.systemGray3))
                    .frame(width: 24, height: 24)
                Text(startLocation)
                    .font(.footnote)
            }
            DottedLine()
                .padding(.horizontal, 12)
            HStack {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.systemGray3))
                    .overlay(
                        Image(systemName: "figure.walk")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 8, height: 13)
                    )
                
                Text("\(walkingDistance) m walking (\(walkingTime) minutes)")
                    .font(.footnote)
            }
        }
    }
}


#Preview {
    PathStart(startLocation: "The Breeze", walkingDistance: 400, walkingTime: 20)
    Spacer()
}
