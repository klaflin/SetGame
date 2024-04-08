//
//  CardView.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/27/24.
//

import SwiftUI
import CoreGraphics

struct CardView: View {
    typealias Card = SetGame<CardContent>.Card
    let card: Card
    
    init(_ card: Card, color: Color = .black) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader(){geometry in
            let cardAspectRatio =   geometry.size.width / geometry.size.height
            let contentAspectRatio = cardAspectRatio * 3
            
            ZStack{
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(.white)
                    .stroke(card.isSelected ? borderColor : .gray, lineWidth: card.isSelected ? Constants.CardOutline.selectedWidth : Constants.CardOutline.deselectedWidth)
                VStack{
                    ForEach(0..<card.content.numberOfShapes, id: \.self) { _ in
                        shape
                            .minimumScaleFactor(Constants.CardContent.scaleFactor)
                            .aspectRatio(contentAspectRatio, contentMode: .fit)
                            .padding(Constants.inset)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var shape: some View {
        switch card.content.shape {
        case .diamond:
            applyColor(to: Diamond())
        case .squiggle:
            applyColor(to: Squiggle())
        case .oval:
            applyColor(to: Oval())
        }
    }
    
    @ViewBuilder
    private func applyColor(to shape: some InsettableShape) -> some View {
        switch card.content.shading {
        case .solid:
            shape.fill(color)
        case .striped:
            StripedShape(borderLineWidth: Constants.lineWidth, color: color, shape: shape)
        case .open:
            shape.strokeBorder(color, lineWidth: Constants.lineWidth)
                
        }
    }
    
    private var color: Color {
        switch card.content.color {
        case .pink:
            return Color("SetPink")
        case .blue:
            return Color("SetBlue")
        case .purple:
            return Color("SetPurple")
        }
    }
    
    private var borderColor: Color {
        switch card.isMatched {
        case .positive:
            return card.cheated ? .yellow : .green
        case .neutral:
            return .blue
        case .negative:
            return .red
        }
    }
    
    private struct Constants {
        static let lineWidth : CGFloat = 2
        static let inset : CGFloat = 2
        static let cornerRadius : CGFloat = 12
        struct CardOutline {
            static let selectedWidth : CGFloat = 4
            static let deselectedWidth : CGFloat = 1
        }
        struct CardContent {
            static let smallest : CGFloat = 10
            static let largest : CGFloat = 200
            static let scaleFactor = smallest/largest
            
        }
    }
}

#Preview {
    typealias Card = CardView.Card
    
    return VStack {
        HStack {
            CardView(Card(content: CardContent(numberOfShapes: 1, shape: .diamond, shading: .open, color: .blue), id: 11))
            CardView(Card(content: CardContent(numberOfShapes: 2, shape: .diamond, shading: .solid, color: .purple), id: 12))
            CardView(Card(content: CardContent(numberOfShapes: 3, shape: .diamond, shading: .striped, color: .pink), id: 13))
        }
        HStack {
            CardView(Card(content: CardContent(numberOfShapes: 1, shape: .oval, shading: .open, color: .blue), id: 21))
            CardView(Card(content: CardContent(numberOfShapes: 2, shape: .oval, shading: .solid, color: .purple), id: 22))
            CardView(Card(content: CardContent(numberOfShapes: 3, shape: .oval, shading: .striped, color: .pink), id: 23))
        }
        HStack {
            CardView(Card(content: CardContent(numberOfShapes: 1, shape: .squiggle, shading: .open, color: .blue), id: 31))
            CardView(Card(content: CardContent(numberOfShapes: 2, shape: .squiggle, shading: .solid, color: .purple), id: 32))
            CardView(Card(content: CardContent(numberOfShapes: 3, shape: .squiggle, shading: .striped, color: .pink), id: 33))
        }
    }
    .padding()
}
