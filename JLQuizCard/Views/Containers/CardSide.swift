//
//  CardSide.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
extension QuizCard {
    struct CardSide<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content:() -> Content) {
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                Image(decorative: "CardBackground")
                    .resizable(capInsets: .init(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                content.padding()
            }
            .aspectRatio(4.0 / 2.8, contentMode: .fit)
            .font(Font.system(size: 40.0, design: .rounded))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .frame(height:400)
        }
    }
}

struct CardSide_Previews: PreviewProvider {
    static var previews: some View {
        QuizCard.CardSide {
            Text("Side")
        }
    }
}
