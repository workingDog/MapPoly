//
//  MapViewer.swift
//  MapPoly
//
//  Created by Ringo Wathelet on 2023/10/02.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation


struct MapViewer: View {
    @Environment(PolyModel.self) var polyModel
    
    @State private var mapType: Int = 2
    @State private var modes = MapInteractionModes.all
    
    var mapStyle: MapStyle {
        return switch(mapType) {
            case 0: .standard
            case 1: .hybrid
            case 2: .imagery
            default: .standard
        }
    }
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 35.68, longitude: 139.75), distance: 4000.0, heading: 0, pitch: 0)
    )
    
    @State private var selection: UUID?
    
    var body: some View {
        VStack (alignment: .leading) {
            MapReader { reader in
                
                Map(initialPosition: cameraPosition, bounds: MapCameraBounds(minimumDistance: 0, maximumDistance: 50000), interactionModes: modes,
                    selection: $selection) {
                    
                    // the polygon
                    MapPolygon(coordinates: polyModel.coords)
                        .stroke(.white, lineWidth: 2)
                        .foregroundStyle(.purple.opacity(0.3))
                    
                    // the polygon circle handles
                    ForEach(polyModel.points) { p in
                        Annotation("", coordinate: p.coord) {
                            Circle()
                                .stroke(polyModel.handleColor, lineWidth: 2)
                                .fill((selection == p.id && polyModel.isEditing) ? polyModel.selectColor : polyModel.fillColor)
                                .frame(width: 30, height: 30)
                        }.tag(p.id)
                    }
                }
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { drag in
                                if polyModel.isMoving {
                                    polyModel.doMove(drag)
                                } else {
                                    if polyModel.isEditing,
                                       selection != nil,
                                       let location = reader.convert(drag.location, from: .local) {
                                        if let index = polyModel.points.firstIndex(where: { $0.id == selection }) {
                                            polyModel.points[index].coord = location
                                        }
                                    }
                                }
                            }
                            .simultaneously(with: SpatialTapGesture()
                                .onEnded { tap in
                                    if polyModel.isAdding, let location = reader.convert(tap.location, from: .local) {
                                        polyModel.points.append(PolyPoint(coord: location))
                                    }
                                }
                            )
                            .simultaneously(with: RotateGesture()
                                .onChanged { angle in
                                    if polyModel.isRotating {
                                        polyModel.doRotate(angle.rotation.degrees)
                                    }
                                }
                            )
                    )
            }
            .mapStyle(mapStyle)
            .mapControlVisibility(.hidden)
            .edgesIgnoringSafeArea(.all)
            
            Spacer()

            Picker("", selection: $mapType) {
                Text("Standard").tag(0)
                Text("Hybrid").tag(1)
                Text("Satellite").tag(2)
            }
            .pickerStyle(.segmented)
            .frame(width: 222, height: 44)
        }
        .onChange(of: polyModel.isRotating || polyModel.isEditing || polyModel.isMoving) {
            if polyModel.isRotating || polyModel.isEditing || polyModel.isMoving {
                modes.subtract(.all)
            } else {
                modes.update(with: .all)
                selection = nil
            }
        }
    }

}
