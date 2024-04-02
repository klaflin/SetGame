//
//  Squiggle.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/31/24.
//

import SwiftUI
import CoreGraphics

struct Squiggle : Shape, InsettableShape {
    
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let paddingOffset : CGFloat = rect.width * (0.05) + insetAmount
        let radius : CGFloat = rect.height * (2/5)
        
        let control1 = CGPoint(x: rect.minX + paddingOffset * 10, y: rect.minY)
        let control2 = CGPoint(x: rect.maxX - paddingOffset * 10, y: rect.maxY )
        
        let topLeftPoint = CGPoint(x: rect.minX + paddingOffset, y: rect.midY - radius)
        let bottomLeftPoint = CGPoint(x: rect.minX + paddingOffset, y: rect.midY + radius)
        
        let topRightPoint = CGPoint(x: rect.maxX - paddingOffset, y: rect.midY - radius)
        let bottomRightPoint = CGPoint(x: rect.maxX - paddingOffset, y: rect.midY + radius)
        
        var p = Path()
        p.move(to: topLeftPoint)
        p.addCurve(to: topRightPoint, control1: control1, control2: control2)
        p.addLine(to: bottomRightPoint)
        
        p.addCurve(to: bottomLeftPoint, control1: control2, control2: control1)
        p.addLine(to: topLeftPoint)
        p.closeSubpath()
        
        return p
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var squiggle = self
        squiggle.insetAmount += amount
        return squiggle
    }
}

#Preview {
    typealias Card = CardView.Card
    return VStack {HStack {
        CardView(Card(content: CardContent(numberOfShapes: 1, shape: .squiggle, shading: .open, color: .blue), id: 31))
        CardView(Card(content: CardContent(numberOfShapes: 2, shape: .squiggle, shading: .solid, color: .purple), id: 32))
    }
       CardView(Card(content: CardContent(numberOfShapes: 3, shape: .squiggle, shading: .striped, color: .pink), id: 33))
    }
    .padding()
}
