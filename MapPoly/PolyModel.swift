//
//  PolyModel.swift
//  MapPoly
//
//  Created by Ringo Wathelet on 2023/10/02.
//


import Foundation
import CoreLocation
import Observation
import SwiftUI
import MapKit


@Observable class PolyPoint: Identifiable {
    @ObservationIgnored let id = UUID()
    var coord: CLLocationCoordinate2D
    
    init(coord: CLLocationCoordinate2D) {
        self.coord = coord
    }
}

@Observable class PolyModel {
    // drawing state
    var isEditing = false
    var isAdding = false
    var isDeleting = false
    var isMoving = false
    var isRotating = false

    var points = [PolyPoint]()

    // not used yet
    // var polyList = [MapPoly]()
    
    // looks
    var handleColor = Color.black.opacity(0.9)
    var lineColor = Color.red.opacity(0.9)
    var fillColor = Color.red.opacity(0.8)
    var selectColor = Color.green.opacity(0.9)
    
    func resetStates(to s: Bool) {
        isEditing = s
        isAdding = s
        isDeleting = s
        isMoving = s
        isRotating = s
    }
}

// not in use
@Observable class MapPoly: Identifiable {
    @ObservationIgnored let id = UUID()
    var coords: [PolyPoint]
    
    init(coords: [PolyPoint]) {
        self.coords = coords
    }
}
