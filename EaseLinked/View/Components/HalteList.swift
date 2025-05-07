//
//  HalteList.swift
//  BSDLink
//
//  Created by Farida Noorseptiyanti on 02/04/25.
//

/** Complete **/

import SwiftUI

struct HalteList: View {
    var halteNames : [BusStop]

    var body: some View {
        List(halteNames) { halte in
            HStack {
                Image(systemName: "mappin") // Ikon lokasi
                Text(halte.name) // Nama halte
            }
            .padding(.vertical, 8)
        }
    }
}
