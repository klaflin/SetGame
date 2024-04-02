//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/26/24.
//

import SwiftUI

///VIEW MODEL
class SetGameViewModel: ObservableObject {
    @Published private var game: SetGame<CardContent>
    
    init(){
        let content = SetGameViewModel.buildContentArray()
        game = SetGame<CardContent>(setComparitor: CardContent.areTheCardsASet, cardContents: content)
    }
    
    //MARK: Computed Vars
    var cards: [SetGame<CardContent>.Card] { game.dealtCards }
    
    var selectedThreeCards: Bool { game.selectedCards.count == 3 }
    
    var score : Int { game.score }
    
    var cardsLeftInDeck : Int { game.unDealtCards.count }
    
    //MARK: Intent Functions
    func newGame(){
        let content = SetGameViewModel.buildContentArray()
        game = SetGame<CardContent>(setComparitor: CardContent.areTheCardsASet, cardContents: content)
    }
    
    func deal() {
        game.deal()
    }
    
    func submitSet() {
        game.checkSet()
    }
    
    func selectCard(_ card: SetGame<CardContent>.Card){
        print("VM select card")
        game.selectCard(card)
    }
    
    //MARK: UTIL FUNCTIONS
    
    static private func buildContentArray() -> [CardContent] {
        var contentArray: [CardContent] = []
        for numShape in 1...3{
            for color in CardContent.CardColor.allCases {
                for shape in CardContent.CardShape.allCases {
                    for shading in CardContent.CardShading.allCases {
                        let content = CardContent(numberOfShapes: numShape, shape: shape, shading: shading, color: color)
                        contentArray.append(content)
                    }
                }
            }
        }
        return contentArray
    }
}
