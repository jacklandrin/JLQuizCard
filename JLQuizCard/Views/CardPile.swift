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
    @State var currentIndex = 0
    @State var isAnimation:Bool = false
    @State var isShowList = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: CardInfo.defaultFetchRequest)
    var cards:FetchedResults<CardInfo>
    @State var cardPile:[Card] = [Card]()
    @State var shouldRotate = false
    
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
                    ForEach((0..<self.cardPile.count).reversed()) { index in
                        QuizCard(onDragOut:{ d in
                            if (d < 0 && self.currentIndex == 0) || (d > 0 && Int(self.currentIndex) == self.cardPile.count - 1) || self.isAnimation || d == 0 {
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
                        .environmentObject(cardPile[index])
                        .cardTransformed(Double(self.currentIndex), card: index)
                    }
                            
                }.padding(.vertical,80)
                .padding(.horizontal, 14)
                
                Spacer()
                HStack{
                    Button(action:{
                        cards[currentIndex].weight += 2
                        flipNextCard()
                    }) {
                        Text("Hard").foregroundColor(Color.white)
                    }
                    .remenberButtonStyle(color: Color.red)
                    
                    
                    Button(action:{
                        cards[currentIndex].weight += 1
                        flipNextCard()
                    }) {
                        Text("Good").foregroundColor(Color.white)
                    }
                    .remenberButtonStyle(color: Color.green)
                    
                    Button(action:{
                        cards[currentIndex].weight -= 1
                        flipNextCard()
                    }) {
                        Text("Easy").foregroundColor(Color.white)
                    }
                    .remenberButtonStyle(color: Color.gray)
                    
                }
                Spacer().frame(height:60)
            }.onAppear(){
                self.cardPile = [Card]()
                for item in cards {
                    let card = Card.convertCard(cardInfo: item)
                    self.cardPile.append(card)
                }
                print("card pile onAppear fired")
            }
            .changeNavigationTitleAndTrailingButton(title: "QuizCard", trailingText: "Edit", action: {
                self.isShowList = true
            })
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
        
    }
    
    func flipNextCard() {
        if self.currentIndex != self.cardPile.count - 1 {
            withAnimation {
                self.currentIndex += 1
                self.isAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                self.isAnimation = false
            }
            
        }
    }
    
}

//struct CardPile_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPile().environmentObject(CardsPileViewModel())
//    }
//}
