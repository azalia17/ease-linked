//
//  SearchRoutesInfo.swift
//  BSDLink
//
//  Created by Azalia Amanda on 03/04/25.
//

import SwiftUI

struct SearchRoutesInfo: View {
    @Binding var isShow: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Try searching the name of a bus stop to know which routes pass by it.")
                    .padding(.horizontal)
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isShow = false
                    }
                }
            }
            .navigationTitle("Search Info")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}
