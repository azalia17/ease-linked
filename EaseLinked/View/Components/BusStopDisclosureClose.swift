//
//  BusStopDisclosureClose.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct BusStopDisclosureClose<ExpandedContent: View>: View {
    let route: Route
    let busStop: BusStop
    let fromHour: Int
    let fromMinute: Int
    let scheduleIndex: Int
    let isFirstItem: Bool
    let isLastItem: Bool  // Pass info if this is the last item
    let contentExpanded: () -> ExpandedContent
    
    @State private var isExpanded: Bool = true
    @State private var expandedHeight: CGFloat = 0  // Store the expanded height
    
    var isShowPreviewSchedule: Bool = true
    
    
    var body: some View {
        let corner: UIRectCorner = if isLastItem {[.bottomLeft, .bottomRight]} else if isFirstItem {[.topLeft, .topRight]} else {[]}
        HStack(alignment: .top) {
            VStack {
                Rectangle()
                    .fill(!isFirstItem ? Color.blue : .gray.opacity(0.0))
                    .frame(width: 3, height: 32) // Connect to previous item
                    .overlay(content: {
                        Rectangle()
                            .fill(!isFirstItem ? Color.blue : .gray.opacity(0.0))
                            .frame(width: 3, height: 32)
                            .offset(y: 20)
                    })
                
                
                Rectangle()
                    .fill(isLastItem ? .gray.opacity(0.0) : Color.blue)
                    .frame(width: 3, height: 40)
                    .offset(y: 24)
                    .overlay(
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .overlay(content: {
                                Image(systemName:"circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.white.opacity(0.8))
                            })
                    )
                
                Rectangle()
                    .fill(isLastItem ? .gray.opacity(0.0) : Color.blue)
                    .frame(width: 3, height: isExpanded ? expandedHeight : 32)
            }
            .padding(.leading, 4)
            
            ExpandableContentType(
                route: route,
                busStop: busStop,
                scheduleIndex: scheduleIndex,
                fromHour: fromHour,
                fromMinute: fromMinute,
                contentExpanded: contentExpanded,
                isExpanded: $isExpanded,
                expandedHeight: $expandedHeight,
                isShowPreviewSchedule: isShowPreviewSchedule,
                isFirstItem: isFirstItem
            )
        }
        .padding(.leading, 12)
        .frame(alignment: .leading)
        .background(Color.gray.opacity(0.1))
        //        .padding(.bottom, 1)
        //        .background(.white)
        .cornerRadius(10, corners: corner)
    }
}

struct ExpandableContentType<ExpandedContent: View>: View {
    let route: Route
    var busStop: BusStop
    let scheduleIndex: Int
    let fromHour: Int
    let fromMinute: Int
    let contentExpanded: () -> ExpandedContent
    
    @Binding var isExpanded: Bool
    @Binding var expandedHeight: CGFloat
    
    var isShowPreviewSchedule: Bool = true
    
    let isFirstItem: Bool
    
    var body: some View {
        VStack{
            if !isFirstItem {
                Divider()
                    .padding(.trailing)
            }
            HStack {
                ImageStack(images: busStop.images)
                    .offset(y: 18)
                VStack(alignment: .leading) {
                    HStack {
                        Text(busStop.name)
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                            .offset(y: 18)
                        Spacer()
                        Image(systemName: "chevron.up")
                            .rotationEffect(.degrees(isExpanded ? 0 : 90))
                            .foregroundColor(.blue)
                            .offset(x: -8,y: 18)
                        
                    }
                    
                    if isShowPreviewSchedule && !isExpanded{
                        let sched = Schedule.getScheduleBusStopBasedWithTime(route: route, busStopId: busStop.id, index: scheduleIndex, fromHour: fromHour, fromMinute: fromMinute)
                        let previewSchedule : [ScheduleTime] = if sched.isEmpty {[]} else {[sched[0], sched[1]]}
                        // MARK: TODO schedule grid
                        
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .padding(.leading, 8)
            }
            .padding(.leading, 8)
            if isExpanded {
                GeometryReader { geometry in
                    VStack {
                        contentExpanded()
                            .background(GeometryReader { innerGeo in
                                Color.clear
                                    .onAppear {
                                        expandedHeight = innerGeo.size.height + 24
                                    }
                            })
                            .padding(.leading)
                    }
                }
                .frame(height: expandedHeight)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
            
        }
    }
}

#Preview {
    BusStopDisclosureClose(route: Route.all[0], busStop: BusStop.all[0], fromHour: 7, fromMinute: 7, scheduleIndex: 2, isFirstItem: true, isLastItem: false, contentExpanded: {
        Text("a")
    })
}
