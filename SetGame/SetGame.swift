//
//  SetGame.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/26/24.
//

import Foundation

///THE MODEL
struct SetGame<CardContent : Equatable> {
    
    private(set) var deck: [Card]
    private let setComparitor: (Card, Card, Card) -> Bool
    
    init(setComparitor: @escaping (Card, Card, Card) -> Bool, cardContents: [CardContent]){
        self.setComparitor = setComparitor
        deck = []
        var index = 1
        for content in cardContents {
            let card = Card(content: content, id: index)
            deck.append(card)
            index += 1
        }
        deck.shuffle()
        deal()
    }
    
    //MARK: Computed Vars
    var dealtCards : [Card] { get { deck.filter({$0.isFaceUp && !$0.isMatched}) } }
    
    var unDealtCards : [Card] { get { deck.filter({!$0.isFaceUp && !$0.isMatched}) } }
    
    var gameOver : Bool { get { deck.allSatisfy({$0.isFaceUp}) } } //FIXME: This will end the game prematurely; should end only when no more sets are available
    
    var score: Int { get { deck.filter({$0.isMatched}).count } }
    
    var validSetOnBoard : Bool = true //TODO: implement computing logic
    
    var selectedCards : [Card] { get { deck.filter({$0.isSelected && !$0.isMatched }) } }
    
    //MARK: Game functions
    mutating func selectCard(_ card: Card){
        if let chosenIndex = deck.firstIndex(where: {$0.id == card.id}) {
            if  selectedCards.count < 3 || selectedCards.contains(deck[chosenIndex]) {
                deck[chosenIndex].isSelected.toggle()
            }
        }
    }
    
    mutating func checkSet() {
        if selectedCards.count != 3 {
            return
        }
        
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        if setComparitor(card1, card2, card3) { //we have a set
            for card in selectedCards {
                if let index = deck.firstIndex(of: card) {
                    deck[index].isMatched = true
                    deck[index].isSelected = false
                }
            }
            deal()
        } else {
            for card in selectedCards {
                if let index = deck.firstIndex(of: card) {
                    deck[index].isSelected = false
                }
            }
        }
    }
    
    mutating func deal() {
        var count = 3
        if dealtCards.count < 12 { //we have less than 12 cards on the board
            count = 12 - dealtCards.count
        }
        let countCardsToAdd = deck.count >= count ? count : deck.count //can't grab cards that don't exist
        
        for _ in 0..<countCardsToAdd {
            if let firstIndex = deck.firstIndex(where: {!$0.isFaceUp}) {
                deck[firstIndex].isFaceUp = true
            }
        }
    }
    
    //MARK: Card
    struct Card: Identifiable, CustomDebugStringConvertible, Equatable {
        let content: CardContent
        
        var isSelected = false
        var isFaceUp = false
        var isMatched = false
        
        let id: Int
        
        var debugDescription: String {
            "\(id): \(content)"
            //"\(id): \(isMatched) \(isFaceUp)"
        }
    }
}

