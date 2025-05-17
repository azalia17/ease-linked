//
//  RouteSelectedDetail.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 15/05/25.
//

import SwiftUI

struct RouteSelectedDetail: View {
    let generatedRoutes: GeneratedRoute
    let estimatedTimeSpent: Int
    let buses: [Bus]
    let startLocation: String
    let endLocation: String
    let startWalkingTime: Int
    let endWalkingTime: Int
    let scheduleTime: [ScheduleTime]
    
    var body: some View {
        VStack(alignment: .leading){
            RouteNameDetail(routes: generatedRoutes.routes)
                .padding(.bottom, 12)
                .padding(.top, 10)
            
            Text("Estimated Time Spent: \(estimatedTimeSpent) minutes")
                .font(.subheadline)
                .foregroundStyle(Color(.systemGray))
                .padding(.bottom, 28)
            
            BusSection(Buses: buses)
                .padding(.bottom, 28)
            
            Text("STOPS")
                .font(.title3)
                .bold(true)
                .foregroundStyle(.black)
                .padding(.bottom, 14)
            PathStart(startLocation: startLocation, walkingDistance: generatedRoutes.startWalkingDistance, walkingTime: startWalkingTime)
            
            if generatedRoutes.routes.count > 1 {
                RouteTransitStopDetail(
                    generatedRoutes: generatedRoutes,
                    scheduleTime: scheduleTime
                )
            } else {
                RouteDirectStopsDetail(
                    generatedRoutes: generatedRoutes,
                    scheduleTime: scheduleTime
                )
            }
            PathEnd(endLocation: endLocation, walkingDistance: generatedRoutes.endWalkingDistance, walkingTime: endWalkingTime)
        }
        .padding(.bottom, 40)
        
    }
}

struct RouteDirectStopsDetail: View {
    var generatedRoutes: GeneratedRoute
    let scheduleTime: [ScheduleTime]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BusStopBigSection(route: generatedRoutes.routes[0], busStop: generatedRoutes.busStop[0], scheduleIndex: 0, startStop: true, transitStop: false, earliestEta: generatedRoutes.twoEarliestTime) {
                ScheduleGrid(
                    schedules: generatedRoutes.startStopScheduleTime, isRoute7: generatedRoutes.routes[0].id == "route_7"
                )
            }
            BusStopInBetween(color: generatedRoutes.routes[0].color, busStops: generatedRoutes.busStop.filter {
                $0.id != generatedRoutes.busStop[0].id
            }.filter{
                $0.id != generatedRoutes.busStop[generatedRoutes.busStop.count-1].id
            })
            
            BusStopBigSection(route: generatedRoutes.routes[0], busStop: generatedRoutes.busStop[generatedRoutes.busStop.count-1], scheduleIndex: 0, startStop: false, transitStop: false, earliestEta: generatedRoutes.twoEarliestTime) {
                ScheduleGrid(
                    schedules: scheduleTime, isRoute7: generatedRoutes.routes[0].id == "route_7"
                )
            }
        }
    }
}

struct RouteTransitStopDetail: View {
    var generatedRoutes: GeneratedRoute
    let scheduleTime: [ScheduleTime]
    
    var body: some View {
        VStack(spacing: 0){
            BusStopBigSection(route: generatedRoutes.routes[0], busStop: generatedRoutes.busStop[0], scheduleIndex: 0, startStop: true, transitStop: false, earliestEta: generatedRoutes.twoEarliestTime) {
                ScheduleGrid(schedules: generatedRoutes.startStopScheduleTime)
//                ScheduleGrid(
//                    schedules:  ScheduleDetail.getScheduleTime(
//                        schedule: Schedule.getSchedules(by: generatedRoutes.schedulesByStop[generatedRoutes.busStop[0].id ?? ""] ?? ""),
//                        index: 0,
//                        busStopId: generatedRoutes.busStop[0].id
//                    ), isRoute7: generatedRoutes.routes[0].id == "route_7"
//                )
//                Text("No schedule data")
//                if let startSchedules = generatedRoutes.schedulesByStop[generatedRoutes.busStop[0].id ?? ""] {
//                    // Display startSchedules
//                    
//                } else {
//                    Text("No schedule data")
//                }
//                
                

            }
            if !generatedRoutes.fromStartToTransit.isEmpty {
                BusStopInBetween(color: generatedRoutes.routes[0].color, busStops: generatedRoutes.fromStartToTransit)
            }
            BusStopBigSection(route: generatedRoutes.routes[1], busStop: generatedRoutes.transitBusStop[0], scheduleIndex: 0, startStop: false, transitStop: true, previousRouteColor: generatedRoutes.routes[0].color, earliestEta: generatedRoutes.twoEarliestTime) {
                ScheduleGrid(
                    schedules: scheduleTime, isRoute7: generatedRoutes.routes[0].id == "route_7"
                )
            }
            if !generatedRoutes.fromTransitToEnd.isEmpty {
                BusStopInBetween(color: generatedRoutes.routes[1].color, busStops: generatedRoutes.fromTransitToEnd)
            }
            BusStopBigSection(route: generatedRoutes.routes[1], busStop: generatedRoutes.busStop[generatedRoutes.busStop.count-1], scheduleIndex: 0, startStop: false, transitStop: false, earliestEta: generatedRoutes.twoEarliestTime) {
                ScheduleGrid(
                    schedules: scheduleTime, isRoute7: generatedRoutes.routes[0].id == "route_7"
                )
            }
        }
    }
}

#Preview {
//    RouteSelectedDetail()
}
