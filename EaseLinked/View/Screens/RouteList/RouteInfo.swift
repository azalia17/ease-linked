//
//  RouteInfo.swift
//  BSDLink
//
//  Created by Farida Noorseptiyanti on 06/04/25.
//

import SwiftUI

struct RouteInfo: View {
    let routes: [Route]
    @Binding var isShow: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Bus Stops Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bus Stops")
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.6))
                            
                            HStack(alignment: .top) {
                                ImageStack(images: ["Intermoda_1"])
                                
                                Text("Click bus stop image to see the full picture and some additional picture (if any). And you can pinch to zoom in to see the picture better")
                                    .font(.subheadline)
                                    .padding(.leading, 8)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        // Schedule Section
                        ForEach(routes) { route in
                            VStack(alignment: .leading, spacing: 12) {
                                Text("\(route.name)'s Notes")
                                    .font(.headline)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.black.opacity(0.6))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(route.note, id: \.self) { note in
                                        HStack(alignment: .firstTextBaseline) {
                                            Image(systemName: "circle.fill")
                                                .resizable()
                                                .frame(width: 4, height: 4)
                                            Text(note.capitalizingFirstLetter())
                                                .fixedSize(horizontal: false, vertical: true)
                                                .lineLimit(nil)
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                .font(.body)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Bus Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bus")
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.6))
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 4, height: 4)
                                Text("Conventional Bus")
                            }
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 4, height: 4)
                                Text("Electric Bus (showed by")
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.yellow)
                                Text(")")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .menuIndicator(.hidden)
                .scrollIndicators(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isShow = false
                    }
                }
            }
            .navigationTitle("Additional Information")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .padding()
    }
    
}

//#Preview {
//        @Previewable @State var show : Bool = true
//    RouteInfo(routes: [Route.all[0], Route.all[0]])
//}
