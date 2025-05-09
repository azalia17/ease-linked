//
//  OneTimeSearchInfo.swift
//  BSDLink
//
//  Created by Brayen Fredgin Cahyadi on 04/04/25.
//

import SwiftUI

struct OneTimeSearchInfo: View {
    @Binding var showOneTimeSearchInfo: Bool
    
    var body: some View {
        
        ZStack (alignment: .topTrailing){
            Text("Try searching the name of a bus stop to know which routes pass by it.")
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Button(action: {
                showOneTimeSearchInfo = false
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .padding(1)
            }
            .foregroundStyle(.gray)
            
            
        }
        .padding()
        .frame(width: 355, height: 100, alignment: .center)
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}
