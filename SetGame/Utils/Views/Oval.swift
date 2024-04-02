//
//  Oval.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/30/24.
//

import SwiftUI
import CoreGraphics

struct Oval : Shape, InsettableShape {
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let paddingOffset : CGFloat = rect.width * (0.05) + insetAmount
        
        let squashedRect = CGRect(
            x: rect.origin.x + paddingOffset,
            y: 0 + paddingOffset,
            width: rect.width - paddingOffset * 2,
            height: rect.height - paddingOffset * 2
        )
        
        var p = Path()
        p.addEllipse(in: squashedRect)
        return p
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var oval = self
        oval.insetAmount += amount
        return oval
    }
}

#Preview {
    typealias Card = CardView.Card
    return VStack {HStack {
        CardView(Card(content: CardContent(numberOfShapes: 1, shape: .oval, shading: .open, color: .blue), id: 31))
        CardView(Card(content: CardContent(numberOfShapes: 2, shape: .oval, shading: .solid, color: .purple), id: 32))
    }
        CardView(Card(content: CardContent(numberOfShapes: 3, shape: .oval, shading: .striped, color: .pink), id: 33))
    }
    .padding()
}
