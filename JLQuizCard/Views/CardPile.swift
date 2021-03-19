//
//  CardPile.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct CardPile: View {
//    @EnvironmentObject var cardPileViewModel: CardsPileViewModel
    @State var currentIndex = 0.0
    @State var isAnimation:Bool = false
    @State var isShowList = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: CardInfo.defaultFetchRequest)
    var cards:FetchedResults<CardInfo>
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CardList(cards: cards), isActive: $isShowList){
                    Text("")
                }
                    .frame(width: 0, height: 0)
                    .hidden()//add data after popping animation, unless list page will update View in animation, then go back this view in iOS 14
                Text("Ready? Let's review!")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                Divider()
                ZStack {
                    ForEach((0..<self.cards.count).reversed(), id: \.id) { index in
                        QuizCard(cardInfo: cards[index], onDragOut:{ d in
                            if (d < 0 && self.currentIndex == 0) || (d > 0 && Int(self.currentIndex) == self.cards.count - 1) || self.isAnimation || d == 0 {
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
            }
            .changeNavigationTitleAndTrailingButton(title: "QuizCard", trailingText: "Edit", action: {
                self.isShowList = true
            })
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
    
}


//struct CardPile_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPile().environmentObject(CardsPileViewModel())
//    }
//}
