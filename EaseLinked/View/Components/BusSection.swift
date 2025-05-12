//
//  BusTile.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 12/05/25.
//

import SwiftUI

struct BusSection: View {
    let Buses: [Bus]
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded
        ) {
            VStack(alignment: .leading) {
                ForEach(Buses) { bus in
                    HStack {
                        ZStack(alignment: .top) {
                            Image(systemName: "bus.fill")
                                .resizable()
                                .frame(width: 39, height: 41)
                                .foregroundColor(bus.color)
                            Text(bus.route)
                                .font(.headline)
                                .foregroundStyle(bus.color)
                                .padding(.top, 4)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text(bus.platNumber)
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.gray)
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 4)
                                    .background(.gray.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                if bus.isElectric {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                }
                            }
                            Text("Operational Hour: \(bus.operationalHour)")
                                .font(.caption2)
                                .bold()
                                .foregroundColor(.gray)
                        }
                    }
                    Divider()
                }
            }
            .padding(.top, 16)
        }
        label: {
            Text("See which bus you can take for this route")
                .font(.headline)
                .foregroundColor(.black)
        }
        
        .padding(16)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    BusSection(Buses: Bus.all)
}
