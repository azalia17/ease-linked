//
//  RouteInfoSheet.swift
//  EaseLinked
//
//  Created by Azalia Amanda on 17/05/25.
//

import SwiftUI

struct RouteInfoSheet: View {
    let routes : [Route]
    @Binding var showInfo: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(alignment: .top, spacing: 18) {
                        ImageStack(images: ["Intermoda_1", "Intermoda_2"])
                        
                        Text("**Click** bus stop image to see the __full picture__ and some additional picture (if any). And you can **pinch to zoom** in to see the picture better")
                            .font(.footnote)
                            .padding(.leading, 8)
                    }
                } header: {
                    HStack {
                        Image(systemName: "h.circle.fill")
                        Text("Bus stop information")
                    }
                }
                
                Section {
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 4, height: 4)
                            Text("Conventional Bus")
                                .font(.footnote)
                        }
                        
                        HStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 4, height: 4)
                            Text("Electric Bus (showed by")
                                .font(.footnote)
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.yellow)
                            Text(")")
                                .font(.footnote)
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "bus.fill")
                        Text("Bus stop information")
                    }
                }
                
                ForEach(routes) { route in
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(route.note, id: \.self) { note in
                                HStack(alignment: .firstTextBaseline) {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 4, height: 4)
                                    Text(note.capitalizingFirstLetter())
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(nil)
                                        .font(.footnote)
                                }
                            }
                        }
                    } header: {
                        HStack {
                            Text("R\(route.routeNumber)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .background(route.color)
                                .cornerRadius(4)
                            Text(route.name)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInfo = false
                    } label: {
                        Text("Done")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Additional Information")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
