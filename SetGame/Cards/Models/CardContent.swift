//
//  CardContent.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/27/24.
//

import Foundation

struct CardContent : Equatable, CustomDebugStringConvertible {

    let numberOfShapes: Int
    let shape: CardShape
    let shading: CardShading
    let color: CardColor
    
    var debugDescription: String {
        "\(numberOfShapes) \(shape) \(shading) \(color)"
    }
    
    //MARK: Content Comparitor
    static func areTheCardsASet(_ card1: SetGame<CardContent>.Card, _ card2: SetGame<CardContent>.Card, _ card3: SetGame<CardContent>.Card) -> Bool {
        
        let count = checkSetLogic(card1.content.numberOfShapes, card2.content.numberOfShapes, card3.content.numberOfShapes)
        let shape = checkSetLogic(card1.content.shape, card2.content.shape, card3.content.shape)
        let color = checkSetLogic(card1.content.color, card2.content.color, card3.content.color)
        let shade = checkSetLogic(card1.content.shading, card2.content.shading, card3.content.shading)
        
        return count && shape && color && shade
        
    }
    
    static private func checkSetLogic<Content : Equatable> (_ a: Content, _ b: Content, _ c: Content) -> Bool {
        return ((
            a == b && a == c && b == c //all the same
        ) || (
            a != b && a != c && b != c //all different
        ))
    }
    
    //MARK: Card Properties
    enum CardColor: CaseIterable {
        case pink
        case purple
        case blue
    }
    
    enum CardShading: CaseIterable {
        case solid
        case striped
        case open
    }
    
    enum CardShape: CaseIterable {
        case diamond
        case squiggle
        case oval
    }
}
