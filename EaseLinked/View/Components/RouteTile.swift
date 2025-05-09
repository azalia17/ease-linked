//
//  RouteTile.swift
//  BSDLink
//
//  Created by Brayen Fredgin Cahyadi on 30/03/25.
//

/** Complete **/

import SwiftUI

struct RouteTile: View {
    
    var routeName: String
    var stops: Int

    
    var body: some View {
        HStack(){
            VStack(alignment: .leading, spacing: 5){
                Text(routeName)
                    .font(.title3)
                    .bold()
                Text(String(stops) + " Stops")
                    .font(.body)
                    .foregroundColor(.black.opacity(0.7))
            }
            Spacer()
        }
    }
}
