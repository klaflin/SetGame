//
//  DiamondView.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/30/24.
//

import SwiftUI

struct Diamond : Shape {
    func path(in rect: CGRect) -> Path {
        let paddingOffset : CGFloat = rect.width * (0.05)
        
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
        return p
    }
}

#Preview {
    typealias Card = CardView.Card
    return VStack {HStack {
        CardView(Card(content: CardContent(numberOfShapes: 1, shape: .diamond, shading: .open, color: .green), id: 31))
        CardView(Card(content: CardContent(numberOfShapes: 2, shape: .diamond, shading: .solid, color: .purple), id: 32))
    }
        CardView(Card(content: CardContent(numberOfShapes: 3, shape: .diamond, shading: .striped, color: .red), id: 33))
    }
    .padding()
}
