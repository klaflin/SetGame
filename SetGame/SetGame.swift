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
    
    
    private var penalities = 0
    
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
    var dealtCards : [Card] { get { deck.filter({$0.isFaceUp  }) } }
    
    var unDealtCards : [Card] { get { deck.filter({!$0.isFaceUp && !($0.isMatched == .positive)}) } }
    
    var gameOver : Bool { get { deck.allSatisfy({$0.isMatched == .positive}) } }
    
    var score: Int { get { deck.filter({$0.isMatched == .positive && !$0.cheated}).count - self.penalities} }
    
    var selectedCards : [Card] { get { deck.filter({$0.isSelected }) } }
    
    var validSetOnBoard : [Card]? {findValidSetOnBoard()}
    
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
        } else {
            for card in selectedCards {
                if let index = deck.firstIndex(of: card) {
                    deck[index].isMatched = .negative
                }
            }
        }
    }
    
    mutating func deal() {
        clearSelection()
        var count = 3
        if dealtCards.count < 12 { //we have less than 12 cards on the board
            count = 12 - dealtCards.count
        }
        let countCardsToAdd = unDealtCards.count >= count ? count : unDealtCards.count //can't grab cards that don't exist
        for _ in 0..<countCardsToAdd {
            if let firstIndex = deck.firstIndex(where:{unDealtCards.contains($0) }) {
                deck[firstIndex].isFaceUp = true
            }
        }
        
        if findValidSetOnBoard() == nil { //if no valid set after dealing, deal again
            deal()
        }
    }
    
    mutating func cheat() {
        if selectedCards.count == 3 {
            clearSelection()
            deal()
        }
        if let validSet = self.validSetOnBoard {
            if let card = validSet.first(where: {!$0.cheated}) {
                selectCard(card)
                if let index = deck.firstIndex(where: {$0.id == card.id}){
                    deck[index].cheated = true
                }
            }
        }
    }
    
    private func findValidSetOnBoard() -> [Card]? { //FIXME: optimize? O(n^3) currently
        for i in 0...(dealtCards.count - 3) {
            for j in (i+1)...(dealtCards.count - 2) {
                for k in (j+1)...(dealtCards.count - 1) {
                    if setComparitor(dealtCards[i], dealtCards[j], dealtCards[k]){
                        return [dealtCards[i], dealtCards[k], dealtCards[j]]
                    }
                }
            }
        }
        return nil;
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
    
    //MARK: Helper Functions
    private mutating func decideToDeal() {
        if dealtCards.count < 12 {
            deal()
        }
    }
    
    mutating func decideToPenalize() {
        if let _ = findValidSetOnBoard() {
            self.penalities += 3;
        }
    }
    
    //MARK: Card
    struct Card: Identifiable, CustomDebugStringConvertible, Equatable {
        let content: CardContent
        
        var isSelected = false
        var isFaceUp = false
        var isMatched : TriState = .neutral
        
        var cheated = false
        
        let id: Int
        
        var debugDescription: String {
            //"\(id): \(content)"
            "\(id): \(isMatched) \(isFaceUp) \(cheated)"
        }
    }
    
    //MARK: 3-boolean
    enum TriState {
        case positive;
        case neutral;
        case negative;
    }
}

