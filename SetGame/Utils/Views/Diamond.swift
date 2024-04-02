//
//  Diamond.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/30/24.
//

import SwiftUI

struct Diamond : Shape, InsettableShape {
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let paddingOffset : CGFloat = rect.width * (0.05) + insetAmount
        
        let rightPoint = CGPoint(x: rect.maxX - paddingOffset, y: rect.midY)
        let leftPoint = CGPoint(x: rect.minX + paddingOffset, y: rect.midY)
        let topPoint = CGPoint(x: rect.midX, y: rect.minY + paddingOffset)
        let bottomPoint = CGPoint(x: rect.midX, y: rect.maxY - paddingOffset)
        
        var p = Path()
        p.move(to: rightPoint)
        p.addLine(to: bottomPoint)
        p.addLine(to: leftPoint)
        p.addLine(to: topPoint)
        p.addLine(to: rightPoint)
        p.closeSubpath()
        return p
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var diamond = self
        diamond.insetAmount += amount
        return diamond
    }
}

#Preview {
    typealias Card = CardView.Card
    return VStack {HStack {
        CardView(Card(content: CardContent(numberOfShapes: 1, shape: .diamond, shading: .open, color: .blue), id: 31))
        CardView(Card(content: CardContent(numberOfShapes: 2, shape: .diamond, shading: .solid, color: .purple), id: 32))
    }
        CardView(Card(content: CardContent(numberOfShapes: 3, shape: .diamond, shading: .striped, color: .pink), id: 33))
        Diamond().strokeBorder(.blue)
    }
    .padding()
}
