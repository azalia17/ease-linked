//
//  ScheduleGrid.swift
//  BSDLink
//
//  Created by Azalia Amanda on 01/04/25.
//

/** Complete **/

import SwiftUI

struct ScheduleGrids: View {
    var schedules: [ScheduleTime]
    var isMore: Bool = false
    var spacing: CGFloat = 2
    
    var body: some View {
        if (schedules.count > 1) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 61), spacing: spacing)], alignment: .leading, spacing: 8, content: {
                ForEach(schedules) { schedule in
                    ScheduleChip(text: formatTime(from: schedule.time), isRegular: schedule.isRegular)
                }
                if isMore {
                    Chip(text: "...", color: .gray.opacity(0.3), textColor: .gray)
                }
            })
        } else {
            HStack() {
                ScheduleChip(text: "No Schedule Available")
                Spacer()
            }
        }
    }
}

struct ScheduleChip: View {
    var text: String
    var isRegular: Bool = true
    
    var body: some View {
        if isRegular {
            Chip(text: text, color: .gray, textColor: .white)
        } else {
            Chip(text: text, color: .orange.opacity(0.8), textColor: .white.opacity(0.9))
        }
    }
}

//#Preview {
//    ScheduleGrid(schedules: [
//        ScheduleTime(time: timeFrom(15, 15)),
//        ScheduleTime(time: timeFrom(17, 20), isRegular: false)
//    ])
//}
