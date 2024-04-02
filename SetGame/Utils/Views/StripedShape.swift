//
//  StripedShape.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 4/2/24.
//

import SwiftUI

struct StripedShape<T>: View where T: InsettableShape {
    var numberOfStrips: Int = 6 //FIXME: vary by shape size
    var borderLineWidth: CGFloat
    let color : Color
    let shape : T
    
    var body: some View {
        GeometryReader { geometry in
            let lineWidth : CGFloat = max(geometry.size.width / CGFloat(numberOfStrips * 2), 1)
            
            HStack(spacing: 0) {
                ForEach(0..<numberOfStrips, id: \.self) { number in
                    Color.white
                    color.frame(width: lineWidth)
                    if number == numberOfStrips - 1 {
                        Color.white
                    }
                }
            }//.rotationEffect(.degrees(45))
            .mask(shape)
                .overlay(shape.stroke(color, lineWidth: min(borderLineWidth, lineWidth)))
        }
    }
    
}

#Preview {
    VStack {
        HStack{
            StripedShape(borderLineWidth: 8, color: Color("Blue"), shape: Squiggle())
            StripedShape(borderLineWidth: 4, color: Color("Pink"), shape: Oval())
        }
        HStack{
            StripedShape(borderLineWidth: 12, color: Color("Purple"), shape: Diamond())
            StripedShape(borderLineWidth: 2, color: Color.black, shape: Circle())
        }
    }
    .padding()
}
