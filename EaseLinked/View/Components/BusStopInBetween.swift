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
                    .overlay{
                        SolidLine(height: 48, color: color)
                    }
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
                                        SolidLine(height: 20, color: color)
                                            .padding(.horizontal, 7)
                                    }
                            }
                    }
                }
                if isExpanded {
                    SolidLine(height: 6, color: color)
                        .overlay{
                            SolidLine(height: 4, color: color)
                                .offset(y: 2)
                        }
                }
            }
            VStack(alignment: .leading) {
                Divider()
                DisclosureGroup(
                    isExpanded: $isExpanded
                ) {
                    VStack() {
                        ForEach(busStops) { stop in
                            HStack(spacing: 0) {
                                ImageStack(isSmall: true, images: stop.images)
                                    .padding(.trailing, 14)
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
        .padding(.leading, 12)
        .offset(x: isExpanded ? -7 : 0)
    }
}

#Preview {
    BusStopInBetween(color: .yellow, busStops: [BusStop.all[0], BusStop.all[2], BusStop.all[45]])
}
