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

    // looks
    var handleColor = Color.black
    var lineColor = Color.white
    var fillColor = Color.purple
    var selectColor = Color.green
    
    func resetStates(to s: Bool) {
        isEditing = s
        isAdding = s
        isDeleting = s
        isMoving = s
        isRotating = s
    }
}
