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
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    
    @State var cardPile:[Card] = [Card]()
    @State var showGroupSheet = false
    @State var cardPileModel = CardPileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CardList().environmentObject(cardPileModel), isActive: $isShowList){
                    Text("")
                }
                .frame(width: 0, height: 0)
                .hidden()//add data after popping animation, unless list page will update View in animation, then go back this view in iOS 14
                Spacer().frame(height:40)
                Button(action:{
                    showGroupSheet = true
                }){
                    Text(selectingGroupButtonName()).foregroundColor(Color.white)
                }.frame(maxWidth:150, minHeight: 44)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .sheet(isPresented: $showGroupSheet, content: {
                    VStack {
                        Text("Please select a group:")
                        Picker("Please select a group", selection:$cardPileModel.currentGroupIndex) {
                            ForEach(cardPileModel.groupNames.indices, id:\.self) {
                                Text(cardPileModel.groupNames[$0])
                            }
                        }.pickerStyle(WheelPickerStyle())
                        Button(action: {
                            showGroupSheet = false
                            print("currenGroup:\(String(describing: groups[cardPileModel.currentGroupIndex].groupname))")
                            convertToShowCards()
                            currentIndex = 0
                        }) {
                            Text("Done").foregroundColor(Color.white)
                        }.remenberButtonStyle(color: Color.blue)
                    }
//                    Image(uiImage: WallpaperGenerator.shared.generate())
                })
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
                            
                }.padding(.bottom,80)
                .padding(.top, 20)
                .padding(.horizontal, 14)
                
                Spacer()
                HStack{
                    Button(action:{
                        groups[cardPileModel.currentGroupIndex].cardArray[currentIndex].weight += 2
                        flipNextCard()
                    }) {
                        Text("Hard").foregroundColor(Color.white)
                    }
                    .remenberButtonStyle(color: Color.red)
                    
                    Button(action:{
                        groups[cardPileModel.currentGroupIndex].cardArray[currentIndex].weight += 1
                        flipNextCard()
                    }) {
                        Text("Good").foregroundColor(Color.white)
                    }
                    .remenberButtonStyle(color: Color.green)
                    
                    Button(action:{
                        groups[cardPileModel.currentGroupIndex].cardArray[currentIndex].weight -= 1
                        flipNextCard()
                    }) {
                        Text("Easy").foregroundColor(Color.white)
                    }
                    .remenberButtonStyle(color: Color.gray)
                    
                }
                Spacer().frame(height:60)
            }.onAppear(){
                convertToShowCards()
                print("card pile onAppear fired")
            }
            .changeNavigationTitleAndTrailingButton(title: "QuizCard", trailingText: "Edit", action: {
                self.isShowList = true
            })
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
    
    func convertToShowCards() {
        self.cardPile = [Card]()
        guard groups.count > 0 else {
            return
        }
        for item in groups[cardPileModel.currentGroupIndex].cardArray {
            let card = Card.convertCard(cardInfo: item)
            self.cardPile.append(card)
        }
    }
    
    func selectingGroupButtonName() -> String {
        guard groups.count > 0 else {
            return "Group"
        }
        return cardPileModel.groupNames[cardPileModel.currentGroupIndex]
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
            saveContext()
        }
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

//struct CardPile_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPile().environmentObject(CardsPileViewModel())
//    }
//}
