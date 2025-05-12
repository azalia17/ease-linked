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
    let contentExpanded: () -> ExpandedContent
    
    @State private var isExpanded: Bool = false
    @State private var expandedHeight: CGFloat = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0){
                if startStop {
                    DottedLine(height: isExpanded ? 76 - expandedHeight : 54)
                        .padding(.leading, 12)
                } else if transitStop {
                    SolidLine(height: isExpanded ? 76 - expandedHeight:  54, color: transitStop ? previousRouteColor : route.color)
                        .offset(y: 1)
                        .padding(.leading, 12)
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
                                .background(GeometryReader { innerGeo in
                                    Color.clear
                                        .onAppear {
                                            expandedHeight = innerGeo.size.height
                                        }
                                })
                                .padding(.leading)
                        }
                    }
                    .frame(height: expandedHeight)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded.toggle()
                        }
                    }
                
                } label: {
                    DisclosureLabelBusStop(
                        images: busStop.images,
                        busStopName: busStop.name,
                        earliestTime: "08:10",
                        secondEarliestTime: "08:50",
                        isTransit: transitStop
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
    let earliestTime: String
    let secondEarliestTime: String
    let isTransit: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if isTransit {
                Text("Exit the bus and transit here!")
                    .font(.subheadline)
                    .bold(true)
                    .foregroundStyle(.red)
            }
            HStack(spacing: 20) {
                BusStopImageName(images: images, busStopName: busStopName)
                VStack(alignment: .trailing) {
                    Text(earliestTime)
                        .font(.title)
                        .foregroundStyle(.black)
                        .bold(true)
                    Text(secondEarliestTime)
                        .font(.body)
                        .foregroundStyle(.black)
                        
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
            Spacer()
        }
    }
}

#Preview {
    BusStopBigSection(route: Route.all[3], busStop: BusStop.all[0], scheduleIndex: 1, startStop: true, transitStop: false) {
        Text("Hello")
    }
    
    BusStopBigSection(route: Route.all[6], busStop: BusStop.all[5], scheduleIndex: 1, startStop: false, transitStop: true, previousRouteColor: Route.all[3].color) {
        Text("Hello")
    }
    
    BusStopBigSection(route: Route.all[1], busStop: BusStop.all[72], scheduleIndex: 1, startStop: false, transitStop: false) {
        Text("Hello")
    }
}
