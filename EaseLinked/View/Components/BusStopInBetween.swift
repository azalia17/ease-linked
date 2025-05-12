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
    @State private var isExpanded = false
    
    var body: some View {
        HStack{
            VStack(spacing: 0){
                SolidLine(height: 45, color: color)
                if isExpanded {
                    ForEach(busStops) { stop in
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
                    }
                }
                if isExpanded {
                    SolidLine(height: 6, color: color)

                }
            }
            VStack(alignment: .leading) {
                Divider()
                DisclosureGroup(
                    isExpanded: $isExpanded
                ) {
                    VStack() {
                        ForEach(busStops) { stop in
                            HStack(spacing: 14) {
                                ImageStack(isSmall: true, images: stop.images)
                                Text(stop.name)
                                    .font(.callout)
                                Spacer()
                            }
                            .padding(.vertical, 3)
                        }
                    }
                    .padding(.top)
                } label: {
                    Text("\(busStops.count) Bus Stop(s)")
                        .font(.footnote)
                        .foregroundStyle(.black)
                }
                Divider()
            }
        }
    }
}

#Preview {
    BusStopInBetween(color: .yellow, busStops: [BusStop.all[0], BusStop.all[2], BusStop.all[45]])
}
