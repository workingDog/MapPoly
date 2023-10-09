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

    // todo
    func doRotate(_ deg: Double) {
        /*
             c = center
             x` = (x-c)cos - (y-c)sin + cx
             y' = (x-c)sin + (y-c)cos + cy
         */
        let rad = deg < 0 ? 0.01 : -0.01 // in radians
        
        let n = Double(points.count)
        let cy = points.map{ $0.coord.latitude}.reduce(0.0, +) / n
        let cx = points.map{ $0.coord.longitude}.reduce(0.0, +) / n
        
        for i in points.indices {
            points[i].coord.longitude = (points[i].coord.longitude - cx) * cos(rad) - (points[i].coord.latitude - cy) * sin(rad) + cx
            
            points[i].coord.latitude = (points[i].coord.longitude - cx) * sin(rad) + (points[i].coord.latitude - cy) * cos(rad) + cy
        }
    }

    // todo
    func doMove(_ drag: DragGesture.Value) {
        let step = 0.00003

        let stepx = drag.translation.width > 0 ? step : -step
        let stepy = drag.translation.height < 0 ? step : -step

        for i in points.indices {
            points[i].coord.longitude += stepx
            points[i].coord.latitude += stepy
        }
    }

}
