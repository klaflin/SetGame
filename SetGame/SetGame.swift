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
    var dealtCards : [Card] { get { deck.filter({ $0.isFaceUp }) } }
    
    var unDealtCards : [Card] { get { deck.filter( {!$0.isFaceUp && !($0.isMatched == .positive)} ) } }
    
    var gameOver : Bool { get { deck.allSatisfy({$0.isMatched == .positive}) || (unDealtCards.count == 0 && validSetOnBoard == nil) } }
    
    var score: Int { get { deck.filter({$0.isMatched == .positive && !$0.cheated}).count - self.penalities} }
    
    var selectedCards : [Card] { get { deck.filter({$0.isSelected }) } }
    
    var validSetOnBoard : [Card]? { findValidSetOnBoard() }
    
    var setSelected : Bool {get {selectedCards.count == 3 && selectedCards.reduce(true, {prev, cur in prev && cur.isMatched == .positive})}}
    
    //MARK: Game functions
    ///Allows the user to pick one card. Deselection is also allowed.
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
    
    ///Reviews the selected cards to determine if they form a set based on the setComparitor (Card, Card, Card) -> Bool
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
    
    /// Adds cards to the board.
    /// Ensures there are always at least 12 cards, unless the deck is empty. If there are already 12 cards, deals 3 more.
    mutating func deal() {
        clearSelection()
        var count = 3
        if dealtCards.count < 12 { //we have less than 12 cards on the board
            count = 12 - dealtCards.count
        }
        let countCardsToAdd = unDealtCards.count >= count ? count : unDealtCards.count //can't grab cards that don't exist
        for _ in 0..<countCardsToAdd {
            if let firstIndex = deck.firstIndex(where:{ unDealtCards.contains($0) }) {
                deck[firstIndex].isFaceUp = true
            }
        }
        decideToDeal() //if no valid set after dealing, deal again
    }
    
    /// Reveals to the user one card that is part of a valid set on the board. If 3 card are already selected, clears them before computing again.
    mutating func cheat() {
        if selectedCards.count == 3 { //if 3 are already selected, clear the board first
            clearSelection()
            decideToDeal()
        }
        
        if let validSet = validSetOnBoard {
            for card in selectedCards {
                if let index = deck.firstIndex(of: card) { //if a card is selected that isn't in the valid set, deselect
                    if !validSet.contains(deck[index]) {
                        deck[index].isSelected = false
                    }
                }
            }
            
            for card in validSet {
                if let index = deck.firstIndex(of: card){
                    var c = deck[index]
                    if c.cheated { //we've already seen this card; ensure it is selected and move on
                        deck[index].isSelected = true
                        continue
                    }
                    if c.isSelected { //this card is already selected; move on to the next
                        continue
                    }
                    selectCard(card)
                    deck[index].cheated = true
                    break //we've now flipped exactly one card - we can stop for now
                }
            }
        }
    }
    
    /// Searches all possible 3 card groups on the board until a valid set is found. Returns nil if no such set exists.
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
    
    /// Deselects all currently selected cards. If cards are matched, remove them from the board. Otherwise, reset their match status to neutral.
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
    /// Only deal automatically if there are fewer than 12 cards on the board or there is no valid set on the board
    private mutating func decideToDeal() {
        if (dealtCards.count < 12 || self.validSetOnBoard == nil) && self.unDealtCards.count > 0 {
            deal()
        }
    }
    
    //FIXME: is this needed any more, if we are always ensuring a valid set is on the board?
    ///Penalizes the user 3 points if there is a valid set on the board when they choose to deal again
    mutating func decideToPenalize() {
        print(setSelected)
        if self.validSetOnBoard != nil && !setSelected {
            self.penalities += 3;
        }
    }
//    
//    mutating func updateValidSet() {
//        self.validSetOnBoard = findValidSetOnBoard() ?? [0]
//    }
    
    //MARK: STRUCT Card
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
    
    //MARK: ENUM 3-boolean
    enum TriState {
        case positive;
        case neutral;
        case negative;
    }
}

