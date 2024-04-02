//
//  ContentView.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/26/24.
//

import SwiftUI

struct SetGameMainView: View {
    
    @ObservedObject var game: SetGameViewModel
    
    var aspectRatio: CGFloat = 4/5
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text("Score: \(game.score)")
                Spacer()
                Text("Deck Count: \(game.cardsLeftInDeck)")
            }
            .padding()
            
            cards
            buttons
        }
        .padding()
    }
    
    var cards: some View {
        return AspectVGrid(game.cards, aspectRatio: aspectRatio) {
            card in
            CardView(card)
                .aspectRatio(aspectRatio, contentMode: .fit)
                .onTapGesture {
                    game.selectCard(card)
                }
        }
        .padding(2)
    }
    
    
    var buttons: some View {
        HStack{
            Button(action: {game.submitSet()}, label: {
                Text("Submit Set")
            })
            .disabled(!game.selectedThreeCards)
            Spacer()
            Button(action: {game.newGame()}, label: {
                Text("New Game")
            })
            Spacer()
            Button(action: {game.deal()}, label: {
                Text("Deal Cards")
            })
            .disabled(game.cardsLeftInDeck == 0)
        }
    }
}


#Preview {
    SetGameMainView(game: SetGameViewModel())
}
