//
//  RouteCountView.swift
//  BSDLink
//
//  Created by Brayen Fredgin Cahyadi on 01/04/25.
//
/** Complete **/
import SwiftUI

struct RouteCount: View {
    let count: Int
    let isDiscover: Bool
    
    var body: some View {
        HStack {
            Text(isDiscover ? "\(count) Routes" : "\(count) Routes you can take")
                .font(.headline)
                .bold()
                .foregroundColor(.black.opacity(0.8))
            Spacer()
        }
        
    }
}
