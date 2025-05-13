//
//  RouteName.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 09/05/25.
//

import SwiftUI

struct RouteName: View {
    let routes: [Route]
    
    var body: some View {
        if (routes.count > 1) {
            VStack (alignment: .leading, spacing: 0){
                ForEach(routes.indices, id: \.self) { index in
                    if (index == routes.count-1){
                        SingleRouteName(routeNumber: routes[index].routeNumber, routeName: routes[index].name, routeColor: routes[index].color)
                    } else {
                        SingleRouteName(routeNumber: routes[index].routeNumber, routeName: routes[index].name, routeColor: routes[index].color)
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [routes[index].color, routes[index+1].color]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 10, height: 8)
                            .padding(.leading, 13)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            SingleRouteName(routeNumber: routes[0].routeNumber, routeName: routes[0].name, routeColor: routes[0].color)
        }
    }
}


struct SingleRouteName: View {
    let routeNumber: Int
    let routeName: String
    let routeColor: Color
    let secondColor: Color? = nil

    var body: some View {
        HStack (spacing: 8) {
            Text("R\(routeNumber)")
                .font(.caption2)
                .fontWeight(.bold)
                .frame(width: 24)
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .background(routeColor)
                .cornerRadius(4)
                
            Text(routeName)
                .font(.footnote)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

#Preview {
    RouteName(routes: [Route.all[0], Route.all[1]])
    RouteName(routes: [Route.all[3]])
}
