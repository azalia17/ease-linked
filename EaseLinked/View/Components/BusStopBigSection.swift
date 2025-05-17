//
//  BusStopBigSection.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 13/05/25.
//

import SwiftUI

struct BusStopBigSection<ExpandedContent: View>: View {
    let route: Route
    let busStop: BusStop
    let scheduleIndex: Int
    let startStop: Bool
    let transitStop: Bool
    var previousRouteColor: Color = .gray
    let earliestEta: [ScheduleTime]
    let contentExpanded: () -> ExpandedContent
    
    @State private var isExpanded: Bool = false
    @State private var expandedHeight: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0){
                let height = expandedHeight/2 - 10
                
                if startStop {
                    DottedLine(height: 54)
                        .padding(.leading, 12)
                } else if transitStop {
                    SolidLine(height: isExpanded ? height :  54, color: transitStop ? previousRouteColor : route.color)
                        .offset(y: 1)
                        .padding(.leading, 12)
                        .overlay {
                            SolidLine(height: isExpanded ? height :  54, color: transitStop ? previousRouteColor : route.color)
                                .padding(.leading, 12)
                                .offset(y: -4)
                        }
                } else {
                    SolidLine(height: 48, color: transitStop ? previousRouteColor : route.color)
                        .offset(y: 1)
                        .padding(.leading, 12)
                }
                
                Image(systemName: "h.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(transitStop ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [previousRouteColor, route.color]), startPoint: .top, endPoint: .bottom)) : AnyShapeStyle(route.color))
                
                if startStop || transitStop {
                    SolidLine(height: isExpanded ? expandedHeight + 48 : 48, color: route.color)
                        .offset(y: -1)
                        .padding(.leading, 12)
                        .overlay {
                            SolidLine(height: isExpanded ? expandedHeight + 48 : 48, color: route.color)
                                .padding(.leading, 12)
                                .offset(y: 5)
                        }
                } else {
                    DottedLine(height: 54)
                        .padding(.leading, 12)
                        .offset(y: 3)
                }
            }
            
            if startStop || transitStop {
                DisclosureGroup(
                    isExpanded: $isExpanded
                ) {
                    GeometryReader { geometry in
                        VStack {
                            contentExpanded()
                                .padding(.top, 20)
                                .background(GeometryReader { innerGeo in
                                    Color.clear
                                        .onAppear {
                                            expandedHeight = innerGeo.size.height
                                        }
                                })
                                .padding(.leading)
                                .opacity(isExpanded ? 1 : 0)
                        }
                    }
                    .frame(height: expandedHeight)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation() {
                            isExpanded.toggle()
                        }
                    }
                
                } label: {
                    DisclosureLabelBusStop(
                        images: busStop.images,
                        busStopName: busStop.name,
                        earliestEta: earliestEta,
                        isTransit: transitStop,
                        isExpanded: $isExpanded
                    )
                }
            } else {
                BusStopImageName(images: busStop.images, busStopName: busStop.name)
            }
        }

    }
}

struct DisclosureLabelBusStop : View {
    let images: [String]
    let busStopName: String
    let earliestEta: [ScheduleTime]
    let isTransit: Bool
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if isTransit {
                Text("Exit the bus and transit here!")
                    .font(.subheadline)
                    .bold(true)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.leading)
            }
            HStack(spacing: 20) {
                BusStopImageName(images: images, busStopName: busStopName)
                if !isExpanded {
                    if(earliestEta.count > 0) {
                        VStack(alignment: .trailing) {
                            Text(formatTime(from: earliestEta[0].time))
                                .font(.title)
                                .foregroundStyle(.black)
                                .bold(true)
                            Text(formatTime(from: earliestEta[1].time))
                                .font(.body)
                                .foregroundStyle(.black)
                                
                        }
                    } else {
                        Text("-")
                            .font(.title)
                            .foregroundStyle(Color(.systemGray))
                            .bold(true)
                    }
                }
            }
        }
        
    }
}

struct BusStopImageName: View {
    let images: [String]
    let busStopName: String
    
    var body: some View {
        HStack(spacing: 20) {
            ImageStack(images: images)
            Text(busStopName)
                .font(.title3)
                .bold(true)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}
