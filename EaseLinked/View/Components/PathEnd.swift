//
//  PathEnd.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 12/05/25.
//

import SwiftUI

struct PathEnd: View {
    let endLocation: String
    let walkingDistance: Int
    let walkingTime: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.systemGray3))
                    .overlay(
                        Image(systemName: "figure.walk")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 10, height: 15)
                    )
                
                Text("\(walkingDistance) m walking (\(walkingTime) minutes)")
                    .font(.footnote)
            }
            DottedLine()
                .padding(.horizontal, 12)
            HStack {
                Image(systemName: "flag.pattern.checkered.circle.fill")
                    .resizable()
                    .foregroundStyle(Color(.systemGray3))
                    .frame(width: 24, height: 24)
                Text(endLocation)
                    .font(.footnote)
            }
            
            
        }
    }
}

#Preview {
    PathEnd(endLocation: BusStop.all[38].name, walkingDistance: 200, walkingTime: 2000)
    Spacer()
}
