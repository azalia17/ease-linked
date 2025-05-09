//
//  LocationSearchResultCell.swift
//  BSDLink
//
//  Created by Azalia Amanda on 07/04/25.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String
    let isStartLocation: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isStartLocation ? "mappin" : "flag.pattern.checkered")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .bold()
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
        }
        .padding(.leading)
    }
}
//
//#Preview {
//    LocationSearchResultCell(title: "title", subtitle: "subtitle")
//}
