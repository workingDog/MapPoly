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
        HStack (spacing: 5) {
            editPolyButton
            addPolyButton
            deletePolyButton
            rotatePolyButton  // todo
            movePolyButton    // todo
        }
        .buttonStyle(.bordered)
        .frame(width: 400, height: 50)
        .padding([.top,.leading], 20)
    }
    
    var movePolyButton: some View {
        Button(action: { polyModel.isMoving.toggle() }) {
            VStack {
                Image(systemName: "move.3d")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(polyModel.isMoving ? .red : .blue)
                Text(polyModel.isMoving ? "Move on" : "Move")
                    .font(.caption)
                    .foregroundColor(polyModel.isMoving ? .red : .blue)
            }.frame(width: sw, height: sh)
        }
        .buttonStyle(.bordered)
        .scaleEffect(polyModel.isMoving ? 1.2 : 1.0)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var rotatePolyButton: some View {
        Button(action: { polyModel.isRotating.toggle() }) {
            VStack {
                Image(systemName: "rectangle.landscape.rotate")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(polyModel.isRotating ? .red : .blue)
                Text(polyModel.isRotating ? "Turn on" : "Turn")
                    .font(.caption)
                    .foregroundColor(polyModel.isRotating ? .red : .blue)
            }.frame(width: sw, height: sh)
        }
        .buttonStyle(.bordered)
        .scaleEffect(polyModel.isRotating ? 1.2 : 1.0)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var addPolyButton: some View {
        Button(action: { polyModel.isAdding.toggle() }) {
            VStack {
                Image(systemName: "squareshape.controlhandles.on.squareshape.controlhandles")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(polyModel.isAdding ? .red : .blue)
                Text(polyModel.isAdding ? "Add on" : "Add")
                    .font(.caption)
                    .foregroundColor(polyModel.isAdding ? .red : .blue)
            }.frame(width: sw, height: sh)
        }
        .buttonStyle(.bordered)
        .scaleEffect(polyModel.isAdding ? 1.2 : 1.0)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var deletePolyButton: some View {
        Button(action: {
            polyModel.resetStates(to: false)
            polyModel.isDeleting = true
            polyModel.points.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                polyModel.isDeleting = false
            }
        }) {
            VStack {
                Image(systemName: "flame")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(polyModel.isDeleting ? .red : .blue)
                Text("Delete")
                    .font(.caption)
                    .foregroundColor(polyModel.isDeleting ? .red : .blue)
            }.frame(width: sw, height: sh)
        }
        .buttonStyle(.bordered)
        .scaleEffect(polyModel.isDeleting ? 1.2 : 1.0)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var editPolyButton: some View {
        Button(action: { 
            polyModel.isEditing.toggle()
            polyModel.isAdding = false
        }) {
            VStack {
                Image(systemName: "skew")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(polyModel.isEditing ? .red : .blue)
                Text(polyModel.isEditing ? "Edit on" : "Edit off")
                    .font(.caption)
                    .foregroundColor(polyModel.isEditing ? .red : .blue)
            }.frame(width: sw, height: sh)
        }
        .buttonStyle(.bordered)
        .scaleEffect(polyModel.isEditing ? 1.2 : 1.0)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
 
}
