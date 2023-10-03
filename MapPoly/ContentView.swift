//
//  ContentView.swift
//  MapPoly
//
//  Created by Ringo Wathelet on 2023/10/02.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @Environment(PolyModel.self) var polyModel
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            MapViewer()
            ToolbarView()
        }
    }
}

#Preview {
    ContentView()
}
