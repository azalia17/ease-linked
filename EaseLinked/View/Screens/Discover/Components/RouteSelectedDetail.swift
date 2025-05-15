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
    let walkingTime: Int
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
            PathStart(startLocation: startLocation, walkingDistance: generatedRoutes.walkingDistance, walkingTime: walkingTime)
            BusStopBigSection(route: generatedRoutes.routes[0], busStop: generatedRoutes.busStop[0], scheduleIndex: 0, startStop: true, transitStop: false) {
                ScheduleGrid(
                    schedules: scheduleTime, isRoute7: generatedRoutes.routes[0].id == "route_7"
                )
            }
            if generatedRoutes.routes.count > 2 {
                ForEach (1..<(generatedRoutes.routes.count-2), id: \.self) { index in
                    BusStopBigSection(route: generatedRoutes.routes[index], busStop: generatedRoutes.busStop.filter {
                        $0.routes.contains(generatedRoutes.routes[index - 1].id) && $0.routes.contains(generatedRoutes.routes[index].id)
                    }.first ?? BusStop.all[0], scheduleIndex: 0, startStop: false, transitStop: true, previousRouteColor: generatedRoutes.routes[index-1].color) {
                        ScheduleGrid(
                            schedules: scheduleTime, isRoute7: generatedRoutes.routes[0].id == "route_7"
                        )
                    }
                }
            }
        }
    }
}

#Preview {
//    RouteSelectedDetail()
}
