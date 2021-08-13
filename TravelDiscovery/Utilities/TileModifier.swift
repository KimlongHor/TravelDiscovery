//
//  TileModifier.swift
//  TravelDiscovery
//
//  Created by horkimlong on 28/7/21.
//

import SwiftUI

extension View {
    func asTile() -> some View {
        modifier(TileModifer())
    }
}

struct TileModifer: ViewModifier {
    
    // detemine either the phhone is in darkmode or normal
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(Color.tileBackground)
            .cornerRadius(5)
            .shadow(color: .init(.sRGB, white: 0.8, opacity: colorScheme == .light ? 1 : 0), radius: 4, x: 0.0, y: 2)
    }
}
