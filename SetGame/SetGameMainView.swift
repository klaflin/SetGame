//
//  ContentView.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 3/26/24.
//

import SwiftUI

struct SetGameMainView: View {
    
    @ObservedObject var game: SetGameViewModel
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            let portrait  = (hSizeClass == .compact && vSizeClass == .regular)
            
            DynamicStack(defaultInPortrait: .veritcal, hStackSpacing: Constants.hStackSpacing){
                cards
                DynamicStack(defaultInPortrait: .horizontal, hStackSpacing: Constants.hStackSpacing) {
                    deck
                    stats
                }.frame(
                    maxWidth: portrait ? geometry.size.width : geometry.size.width * Constants.Deck.sizeLimitMultiplier,
                        maxHeight:  portrait ? geometry.size.height * Constants.Deck.sizeLimitMultiplier : geometry.size.height
                )
            }
            .padding()
        }
    }
    
    var deck: some View {
        let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        
        return ZStack(){
            ForEach(0...1, id: \.self) {num in
                base
                    .fill(.gray)
                    .stroke(.white)
                    .offset(CGSize(width: Constants.Deck.maxOffset - Constants.Deck.offset * CGFloat(num), height: Constants.Deck.maxOffset - Constants.Deck.offset * CGFloat(num)))
                    .aspectRatio(Constants.aspectRatio, contentMode: .fit)
            }
            base
                .stroke(.black, lineWidth: Constants.Deck.lineWidth)
                .fill(.gray)
                .aspectRatio(Constants.aspectRatio, contentMode: .fit)
            
            StripedShape(borderLineWidth: Constants.Deck.lineWidth,
                         color: Color("SetPurple"),
                         shape: base.inset(by: Constants.Deck.offset)
            )
            .aspectRatio(Constants.aspectRatio, contentMode: .fit)
        }
        .rotationEffect(Angle(degrees: 90))
            .onTapGesture {
                game.submitSet()
                game.deal()
            }
        
    }
    
    var cards: some View {
        return AspectVGrid(game.cards, aspectRatio: Constants.aspectRatio) {
            card in
            CardView(card)
                .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                .onTapGesture {
                    game.selectCard(card)
                }
        }
        .padding(2)
    }
    
    var stats: some View {
        VStack(){
            Text("Deck Size: \(game.cardsLeftInDeck)")
            Text("Score: \(game.score)")
            Button(action: {game.newGame()}, label: {
                Text("New Game")
            })
        }.font(.callout)
    }
    
    struct Constants {
        static let aspectRatio : CGFloat = 4/5
        static let cornerRadius : CGFloat = 15
        static let hStackSpacing : CGFloat = 50
        static let vStackSpacing : CGFloat = 0
        
        struct Deck {
            static let offset : CGFloat = 5
            static let maxOffset : CGFloat = 10
            static let lineWidth : CGFloat = 4
            static let decalAspectRatio = Constants.aspectRatio * 3
            static let sizeLimitMultiplier : CGFloat = 1/7
        }
    }
}


#Preview {
    SetGameMainView(game: SetGameViewModel())
}

