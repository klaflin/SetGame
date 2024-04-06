//
//  DynamicStack.swift
//  SetGame
//
//  Created by KELLIE LAFLIN on 4/5/24.
//

import SwiftUI

/// presents an HStack or a VStack of the given content based on the device's dynamic size class 
struct DynamicStack<Content : View> : View {
    let defaultInPortrait : StackType
    
    var hStackAlignment = VerticalAlignment.center
    var vStackAlignment = HorizontalAlignment.center
    var hStackSpacing : CGFloat?
    var vStackSpacing : CGFloat?
    
    @ViewBuilder var content : () -> Content
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    
    var body: some View {
        let portrait  = (hSizeClass == .compact && vSizeClass == .regular)
        switch defaultInPortrait {
        case .horizontal:
            if portrait {
                HStack(alignment: hStackAlignment, spacing: hStackSpacing, content: content)
            } else {
                VStack(alignment: vStackAlignment, spacing: vStackSpacing, content: content)
            }
        case .veritcal:
            if portrait {
                VStack(alignment: vStackAlignment, spacing: vStackSpacing, content: content)
            }
            else {
                HStack(alignment: hStackAlignment, spacing: hStackSpacing, content: content)
            }
        }
    }
    
    enum StackType {
        case horizontal
        case veritcal
    }
}

#Preview {
    DynamicStack(defaultInPortrait: .veritcal){
        Spacer()
        DynamicStack(defaultInPortrait: .horizontal){
            Text("horizontal!")
            Text("in portrait")
        }
        Spacer()
        DynamicStack(defaultInPortrait: .veritcal, vStackAlignment: .leading, vStackSpacing: 10){
            Text("vertical!")
            Text("in portrait")
        }
        Spacer()
        DynamicStack(defaultInPortrait: .horizontal, hStackAlignment: .firstTextBaseline){
            Text("Testing")
            Text("Spacing")
            Text("and Alignment")
        }
        Spacer()
    }.padding()
}
