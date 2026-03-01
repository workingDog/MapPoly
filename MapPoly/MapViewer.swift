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
                
                Map(initialPosition: cameraPosition,
                    bounds: MapCameraBounds(minimumDistance: 0, maximumDistance: 50000),
                    interactionModes: polyModel.canMapInteract ? .all : [],
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
                                .fill((selection == p.id && polyModel.tool == .edit) ? polyModel.selectColor : polyModel.fillColor)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                    .simultaneousGesture(
                        DragGesture().onChanged { drag in
                            switch polyModel.tool {
                                case .move:
                                    polyModel.doMove(drag)
                                case .edit:
                                    guard let id = selection,
                                          let location = reader.convert(drag.location, from: .local),
                                          let i = polyModel.points.firstIndex(where: { $0.id == id }) else { return }
                                    polyModel.points[i].coord = location
                                case .rotate:
                                    polyModel.doRotate(drag)
                                default:
                                    break
                            }
                        }
                    )
                    .simultaneousGesture(
                        SpatialTapGesture().onEnded { tap in
                            guard polyModel.tool == .add,
                                  let location = reader.convert(tap.location, from: .local) else { return }
                            polyModel.points.append(.init(coord: location))
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
    }
    
}
