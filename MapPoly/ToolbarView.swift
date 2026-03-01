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
                title: polyModel.tool == .edit ? "Edit on" : "Edit off",
                isActive: polyModel.tool == .edit,
                action: {
                    polyModel.tool = polyModel.tool == .edit ? .view : .edit
                }
            )
            
            toolbarButton(
                systemName: "squareshape.controlhandles.on.squareshape.controlhandles",
                title: polyModel.tool == .add ? "Add on" : "Add",
                isActive: polyModel.tool == .add,
                action: {
                    polyModel.tool = polyModel.tool == .add ? .view : .add
                }
            )
            
            toolbarButton(
                systemName: "flame",
                title: "Delete",
                isActive: polyModel.tool == .delete,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        polyModel.tool = .view
                        polyModel.points.removeAll()
                    }
                }
            )
            
            toolbarButton(
                systemName: "rectangle.landscape.rotate",
                title: polyModel.tool == .rotate ? "Turn on" : "Turn",
                isActive: polyModel.tool == .rotate,
                action: {
                    polyModel.tool = polyModel.tool == .rotate ? .view : .rotate
                }
            )
            
            toolbarButton(
                systemName: "move.3d",
                title: polyModel.tool == .move ? "Move on" : "Move",
                isActive: polyModel.tool == .move,
                action: {
                    polyModel.tool = polyModel.tool == .move ? .view : .move
                }
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
