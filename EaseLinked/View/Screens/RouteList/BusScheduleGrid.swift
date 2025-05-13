//
//  BusScheduleGrid.swift
//  BSDLink
//
//  Created by Azalia Amanda on 03/04/25.
//

/** done **/

import SwiftUI

struct BusScheduleGrid: View {
    let busStopId: String
    let index: Int
    let busSchedules: [Schedule]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(busSchedules) { schedule in
                HStack {
                    Text("\(index)")
                    Text("Schedule \(schedule.idx):")
                        .bold()
                    Text(Bus.getBus(by: schedule.bus).platNumber)
                        .font(.subheadline)
                }
//                .padding(.top)
                
                ScheduleGrids(
                    schedules: ScheduleDetail.getScheduleTime(
                        schedule: schedule.scheduleDetail,
                        index: index,
                        busStopId: busStopId
                    )
                )
                .padding(.bottom, 8)
//                Divider()
//                    .padding(.top)
            }
        }
        .padding(.top)
    }
}

//#Preview {
//    BusScheduleGrid(busStopId: "intermoda", index: 1, busSchedules: Schedule.all)
//}
