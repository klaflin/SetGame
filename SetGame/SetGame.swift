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
    var dealtCards : [Card] { get { deck.filter({$0.isFaceUp && $0.isMatched != .positive}) } }
    
    var unDealtCards : [Card] { get { deck.filter({!$0.isFaceUp && !($0.isMatched == .positive)}) } }
    
    var gameOver : Bool { get { deck.allSatisfy({$0.isMatched == .positive}) } }
    
    var score: Int { get { deck.filter({$0.isMatched == .positive}).count } }
    
    var validSetOnBoard : Bool = true //TODO: implement computing logic
    
    var selectedCards : [Card] { get { deck.filter({$0.isSelected }) } }
    
    //MARK: Game functions
    mutating func selectCard(_ card: Card){
        if let chosenIndex = deck.firstIndex(where: {$0.id == card.id}) {
            if  selectedCards.count < 3  {
                deck[chosenIndex].isSelected.toggle()
                if selectedCards.count == 3 {
                    checkSet()
                }
            } else {
                clearSelection()
                decideToDeal()
                deck[chosenIndex].isSelected.toggle()
            }
        }
        decideToDeal()
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
                    deck[index].isMatched = .positive
                }
            }
            decideToDeal()
        } else {
            for card in selectedCards {
                if let index = deck.firstIndex(of: card) {
                    deck[index].isMatched = .negative
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
    
    private mutating func decideToDeal() {
        if dealtCards.count < 12 {
            deal()
        }
    }
    
    mutating private func clearSelection() {
        for card in selectedCards {
            if let index = deck.firstIndex(of: card) {
                if deck[index].isMatched == .positive {
                    deck[index].isFaceUp = false
                } else {
                    deck[index].isMatched = .neutral
                }
                deck[index].isSelected = false
            }
        }
    }
    
    //MARK: Card
    struct Card: Identifiable, CustomDebugStringConvertible, Equatable {
        let content: CardContent
        
        var isSelected = false
        var isFaceUp = false
        var isMatched : TriState = .neutral
        
        let id: Int
        
        var debugDescription: String {
            "\(id): \(content)"
            //"\(id): \(isMatched) \(isFaceUp)"
        }
    }
    
    //MARK: 3-boolean
    enum TriState {
        case positive;
        case neutral;
        case negative;
    }
}

