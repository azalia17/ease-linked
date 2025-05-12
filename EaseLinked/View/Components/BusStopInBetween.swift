//
//  BusStopInBetween.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import SwiftUI

struct BusStopInBetween: View {
    let color: Color
    let busStops: [BusStop]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ForEach(busStops) { stop in
                HStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 0){
                        SolidLine(height: 15, color: color)
                            .padding(.horizontal, 7)
                        Image(systemName: "h.circle.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(color)
                            .offset(y: -1)
                        SolidLine(height: 15, color: color)
                            .padding(.horizontal, 7)
                            .offset(y: -2)
                            .overlay {
                                SolidLine(height: 15, color: color)
                                    .padding(.horizontal, 7)
                            }
                    }
                    HStack(spacing: 14) {
                        ImageStack(isSmall: true, images: stop.images)
                        Text(stop.name)
                            .font(.callout)
                    }

                }
            }
        }
        .frame(width: .infinity)
    }
}

#Preview {
    BusStopInBetween(color: .yellow, busStops: [BusStop.all[0], BusStop.all[2], BusStop.all[45]])
}
