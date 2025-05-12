//
//  ScheduleGrid.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 12/05/25.
//

import SwiftUI

struct ScheduleGrid: View {
    let schedules: [ScheduleTime]
    var isRoute7 : Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 61), spacing: 2)], alignment: .leading, spacing: 8, content: {
                ForEach(schedules) { schedule in
                    ScheduleItem(time: formatTime(from: schedule.time), isRegular: schedule.isRegular, isPassed: schedule.isPassed)
                }
            })
            
            if !isRoute7 {
                Text("*Weekend and national holidays only")
                    .font(.footnote)
                    .bold(true)
                    .foregroundStyle(Color(.red))
                    .padding(.top, 12)
            }
        }
    }
}

struct ScheduleItem: View {
    let time: String
    let isRegular: Bool
    let isPassed: Bool
    var color: Color = .black
    
    init(time: String, isRegular: Bool, isPassed: Bool) {
        self.time = time
        self.isRegular = isRegular
        self.isPassed = isPassed
        
        self.color = if (self.isPassed) {
            Color(.systemGray3)
        } else if (self.isRegular) {
            Color.black
        } else {
            Color(.red)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(time)
                .font(.callout)
                .bold(true)
                .foregroundStyle(color)
            if !isRegular {
                Text("*")
                    .font(.title)
                    .foregroundStyle(.red)
            }
        }
        .frame(height: 21)
    }
}

#Preview {
    ScheduleGrid(
        schedules: [
            ScheduleTime(time: timeFrom(15, 15), isPassed: true),
            ScheduleTime(time: timeFrom(15, 15), isPassed: true),
            ScheduleTime(time: timeFrom(15, 15), isPassed: true),
            ScheduleTime(time: timeFrom(15, 15), isPassed: true),
            ScheduleTime(time: timeFrom(15, 15), isPassed: true),
            ScheduleTime(time: timeFrom(15, 15), isPassed: true),
            ScheduleTime(time: timeFrom(15, 15), isRegular: false),
            ScheduleTime(time: timeFrom(15, 15)),
            ScheduleTime(time: timeFrom(15, 15)),
            ScheduleTime(time: timeFrom(15, 15)),
            ScheduleTime(time: timeFrom(15, 15)),
            ScheduleTime(time: timeFrom(15, 15)),
            ScheduleTime(time: timeFrom(15, 15)),
            ScheduleTime(time: timeFrom(15, 15), isRegular: false),
            ScheduleTime(time: timeFrom(15, 15), isRegular: false),
            ScheduleTime(time: timeFrom(15, 15), isRegular: false),
            ScheduleTime(time: timeFrom(15, 15), isRegular: false),
            ScheduleTime(time: timeFrom(15, 15), isRegular: false),
        ]
    )
}
