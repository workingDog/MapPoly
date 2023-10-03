//
//  MapPolyApp.swift
//  MapPoly
//
//  Created by Ringo Wathelet on 2023/10/02.
//

import SwiftUI

@main
struct MapPolyApp: App {
    @State private var polyModel = PolyModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(polyModel)
        }
    }
}
