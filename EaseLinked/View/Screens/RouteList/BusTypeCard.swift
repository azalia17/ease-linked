//
//  BusTypeCard.swift
//  BSDLink
//
//  Created by Farida Noorseptiyanti on 02/04/25.
//

/** Complete **/

import SwiftUI

struct BusTypeCard: View {
    
    var busList: [Bus]
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded
        ) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                ForEach(busList) { bus in
                    HStack {
                        Image(systemName: "bus.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.orange)
                        
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Chip(text: bus.platNumber, color: .blue)
                                if bus.isElectric {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                }
                            }
                            Text("Operational Hour: \(bus.operationalHour)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
                }
            }
        }
        label: {
            Text("Bus")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
        }
        .modifier(TextFieldGrayBackgroundColor(
            showClearButton: false, onClear: {}
        ))
    }
}


//#Preview {
//    BusTypeCard(busList: Bus.all)
//}
