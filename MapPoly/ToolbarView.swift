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
    @Environment(PolyModel.self) private var polyModel

    var body: some View {
        HStack(spacing: 8) {
            ForEach(PolyTool.toolbarTools) { tool in
                Button {
                    handleTap(tool)
                } label: {
                    VStack {
                        Image(systemName: tool.icon).resizable().frame(width: 35, height: 35)
                        Text(tool.title).font(.caption)
                    }
                }
                .buttonStyle(.bordered)
                .tint(tint(for: tool, active: polyModel.tool == tool))
                .scaleEffect(polyModel.tool == tool ? 1.2 : 1.0)
                .accessibilityLabel(tool.title)
            }
        }
        .animation(.snappy, value: polyModel.tool)
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func handleTap(_ tool: PolyTool) {
        if tool == .delete {
            polyModel.points.removeAll()
            polyModel.tool = .view
        } else {
            polyModel.tool = (polyModel.tool == tool) ? .view : tool
        }
    }

    private func tint(for tool: PolyTool, active: Bool) -> Color {
        return active ? .red : .black
    }
}
