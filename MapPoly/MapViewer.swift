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
    
    @State private var mapType: Int = 0
    @State private var dragId = UUID()
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
    
    var body: some View {
        VStack (alignment: .leading) {
            MapReader { reader in
                Map(position: $cameraPosition, interactionModes: modes) {
                    // the polygon circle handles
                    ForEach(polyModel.points) { p in
                        Annotation("", coordinate: p.coord) {
                            Circle()
                                .stroke(polyModel.handleColor, lineWidth: 2)
                                .fill(dragId == p.id ? polyModel.selectColor : polyModel.fillColor)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    if dragId == p.id {
                                        dragId = UUID()
                                        polyModel.isEditing = false
                                    } else {
                                        polyModel.isEditing = true
                                        dragId = p.id
                                    }
                                }
                        }
                    }
                    // the connecting lines
                    MapPolyline(coordinates: polyModel.points.map{$0.coord}, contourStyle: .straight)
                        .stroke(polyModel.lineColor, style: StrokeStyle(lineWidth: 2, dash: [5]))
                }
                .onTapGesture { pos in
                    if polyModel.isAdding, let location = reader.convert(pos, from: .local) {
                        polyModel.points.append(PolyPoint(coord: location))
                    }
                }
                .simultaneousGesture(DragGesture()
                    .onChanged { pos in
                        if let point = polyModel.points.first(where: {$0.id == dragId}),
                           polyModel.isEditing,
                           let location = reader.convert(pos.location, from: .local) {
                            point.coord = location
                        }
                    }
                    .onEnded { pos in
                        
                    }
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
        .onChange(of: polyModel.isEditing) {
            if polyModel.isEditing {
                modes.subtract(.pan)
            } else {
                modes.update(with: .all)
                dragId = UUID()
            }
        }
    }

}
