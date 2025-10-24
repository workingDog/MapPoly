//
//  ToolbarView.swift
//  MapPoly
//
//  Created by Ringo Wathelet on 2023/10/02.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation


struct ToolbarView: View {
    @Environment(PolyModel.self) var polyModel
    
    let sw: CGFloat = 60
    let sh: CGFloat = 50
    
    var body: some View {
        HStack(spacing: 5) {
            toolbarButton(
                systemName: "skew",
                title: polyModel.isEditing ? "Edit on" : "Edit off",
                isActive: polyModel.isEditing,
                action: {
                    polyModel.isEditing.toggle()
                    polyModel.isAdding = false
                }
            )
            
            toolbarButton(
                systemName: "squareshape.controlhandles.on.squareshape.controlhandles",
                title: polyModel.isAdding ? "Add on" : "Add",
                isActive: polyModel.isAdding,
                action: { polyModel.isAdding.toggle() }
            )
            
            toolbarButton(
                systemName: "flame",
                title: "Delete",
                isActive: polyModel.isDeleting,
                action: {
                    polyModel.isDeleting = true
                    withAnimation(.easeInOut(duration: 0.2)) {
                        polyModel.resetStates(to: false)
                        polyModel.points.removeAll()
                        polyModel.isDeleting = false
                    }
                }
            )
            
            toolbarButton(
                systemName: "rectangle.landscape.rotate",
                title: polyModel.isRotating ? "Turn on" : "Turn",
                isActive: polyModel.isRotating,
                action: { polyModel.isRotating.toggle() }
            )
            
            toolbarButton(
                systemName: "move.3d",
                title: polyModel.isMoving ? "Move on" : "Move",
                isActive: polyModel.isMoving,
                action: { polyModel.isMoving.toggle() }
            )
        }
        .buttonStyle(.bordered)
        .frame(width: 400, height: 50)
        .padding([.top, .leading], 10)
    }
    
    @ViewBuilder
    func toolbarButton(
        systemName: String,
        title: String,
        isActive: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(isActive ? .red : .blue)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isActive ? .red : .blue)
            }
            .frame(width: sw, height: sh)
        }
        .buttonStyle(.bordered)
        .scaleEffect(isActive ? 1.2 : 1.0)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
