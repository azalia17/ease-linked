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
                Image(systemName: "mappin")
                Text(halte.name)
            }
            .padding(.vertical, 8)
        }
    }
}
