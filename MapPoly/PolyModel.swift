//
//  PolyModel.swift
//  MapPoly
//
//  Created by Ringo Wathelet on 2023/10/02.
//
import Foundation
import CoreLocation
import SwiftUI


enum PolyTool: Equatable {
    case view, add, edit, move, rotate, delete
}

struct PolyPoint: Identifiable {
    let id = UUID()
    var coord: CLLocationCoordinate2D
}

@Observable
final class PolyModel {
    var tool: PolyTool = .view
    var points: [PolyPoint] = []
    
    var coords: [CLLocationCoordinate2D] { points.map(\.coord) }
    var canMapInteract: Bool { tool == .view }
    
    // looks
    var handleColor = Color.black
    var lineColor = Color.white
    var fillColor = Color.purple
    var selectColor = Color.green
    
    // todo
    func doRotate(_ drag: DragGesture.Value) { }

    // todo
    func doMove(_ drag: DragGesture.Value) { }
}
