//
//  Cardify.swift
//  Memorize2
//
//  Created by Olivia Zhang on 2022-05-21.
//

import SwiftUI
 
struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool) { // now for when people are creating our view modifier
        rotation = isFaceUp ? 0 : 180 // sets up the rotation
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue}
    }
    
    // the animation is not about "faceup"-ness, rather, how far the card is in the rotation
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 { // 0 - 90 is the front
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else { // 90 - 180 is the back
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0) // < 90, front, when the emoji should be opaque
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
