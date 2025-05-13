//
//  RouteDetail.swift
//  BSDLink
//
//  Created by Azalia Amanda on 03/04/25.
//

import SwiftUI

struct RouteDetail: View {
    var route: Route
    @State var showInfoSheet : Bool = false
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(.gray.opacity(0.4))
                .frame(width: 48, height: 6)
                .padding(.bottom, 12)
                .padding(.top, 12)
            
            HStack {
                Text("Route Detail")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showInfoSheet = true
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
//            .padding(.top, 50)
            
            ScrollView {
                VStack(alignment: .leading) {
                    BusTypeCard(busList: Bus.getBusses(by: route.bus))
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("Bus Stops")
                        .font(.headline)
                        .bold()
                    HStack(alignment: .center){
                        Text("Schedule Type: ")
                            .font(.caption)
                        ScheduleChip(text: "Weekday")
                        ScheduleChip(text: "Weekend", isRegular: false)
                    }.padding(.bottom, 8)
                    VStack(spacing: 0) {
                        ForEach(route.busStops.indices, id: \.self) { index in
                            ScheduleExpandableForDetailRoute(
                                index: index,
                                route: route,
                                fromHour: 10,
                                fromMinute: 0
                            )
                        }
                    }
                }
            }
            .padding(.bottom, 100)
            .menuIndicator(.hidden)
            .scrollIndicators(.hidden)
            .sheet(isPresented: $showInfoSheet) {
                RouteInfo(routes: [route], isShow: $showInfoSheet)
            }
        }
        .padding(.horizontal)
    }
}

struct ScheduleExpandableForDetailRoute: View {
    var index : Int
    var route: Route
    let fromHour: Int
    let fromMinute: Int
    
    var body: some View {
        let currentBusStopId = route.busStops[index]
        
        let matchingDetails = route.schedule
            .flatMap { Schedule.getSchedules(by: [$0]) }
            .flatMap { $0.scheduleDetail }
            .map { ScheduleDetail.getScheduleDetail(by: $0) }
            .filter { $0.busStop == currentBusStopId }
        
        let stopIndex = matchingDetails.indices.contains(index)
        ? matchingDetails[index].index
        : matchingDetails.first?.index ?? 0
        
        ItemExpandable(
            route: route,
            busStop: BusStop.getSingleStop(by: currentBusStopId),
            fromHour: fromHour,
            fromMinute: fromMinute,
            scheduleIndex: stopIndex,
            isFirstItem: index == 0,
            isLastItem: index == route.busStops.count - 1,
            contentExpanded: {
                BusScheduleGrid(busStopId: currentBusStopId, index: index+1, busSchedules: Schedule.getSchedules(by: route.schedule))
                .padding([.top, .trailing])
                .padding(.top, 8)
            },
            isShowPreviewSchedule: false
        )
    }
}

//#Preview {
//    @Previewable @State var show : Bool = false
//    RouteDetail(route: Route.all[0])
//}
