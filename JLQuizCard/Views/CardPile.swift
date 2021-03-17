//
//  CardPile.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct CardPile: View {
    @EnvironmentObject var cardPileViewModel: CardsPileViewModel
    @State var currentIndex = 0.0
    @State var isAnimation:Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text(cardPileViewModel.title)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                Divider()
                ZStack {
                    ForEach((0..<self.cardPileViewModel.pile.count).reversed()) { index in
                        QuizCard(card: self.cardPileViewModel.pile[index], onDragOut:{ d in
                            if (d < 0 && self.currentIndex == 0) || (d > 0 && Int(self.currentIndex) == self.cardPileViewModel.pile.count - 1) || self.isAnimation || d == 0 {
                                return
                            }
                            
                            if d < 0 {
                                withAnimation {
                                    self.currentIndex += -1
                                    self.isAnimation = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                                                           self.isAnimation = false
                                                       }
                            } else {
                                self.currentIndex += 1
                                print("current index\(self.currentIndex)")
                            }
                        }, sequence: Int(index + 1))
                            .cardTransformed(self.currentIndex, card: index)
                        }
                            
                }.padding(.vertical,80)
                .padding(.horizontal, 14)
                Spacer()
            }.changeNavigationTitleAndTrailingLink(title: "QuizCard", destination: CardList().environmentObject(self.cardPileViewModel), trailingText: "Edit")
            
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
    
}


struct CardPile_Previews: PreviewProvider {
    static var previews: some View {
        CardPile().environmentObject(CardsPileViewModel())
    }
}
