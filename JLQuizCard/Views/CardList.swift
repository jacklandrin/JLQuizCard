//
//  CardList.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/6.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import CoreData

struct CardList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    //@FetchRequest(fetchRequest: CardInfo.defaultFetchRequest)
    var cards:FetchedResults<CardInfo>
    @State var isShowEditor = false
    
    
    var body: some View {
        VStack {
//            Button(action:testAddCard){
//                Text("test")
//            }
            NavigationLink(destination: CardEditor(isNewOne: true, card: nil, finishEditCard: { c in
                 self.addCard(card: c)
            }), isActive: $isShowEditor) {
                Text("")
            }.frame(width: 0, height: 0)
            .hidden()
            List {
                ForEach(cards.indices, id:\.id) { i in
                    NavigationLink(destination: CardEditor(isNewOne: false, card: cards[i], finishEditCard: { c in
                            self.modifyCard(card: c, index: i)
                        })){
                           Text(cellText(card: cards[i]))
                    }

                }.onDelete(perform: delete)
            
            } .listStyle(PlainListStyle())
            .changeNavigationTitleAndTrailingButton(title: "Card List", trailingText: "Add", action: {
                self.isShowEditor = true
            })

        }
    }
    
//    func testAddCard() -> Void {
//        let card = Card(id: UUID(), question: "test", answer: "test", example: "test", languageCode: "en-GB", type: .showText)
//        self.addCard(card: card)
//    }
    
    func cellText(card: CardInfo) -> String {
        let prefix = (card.type == CardType.speech.rawValue) ? "🗣:" : "Text:"
        return prefix + card.question!
    }
    
    func delete(at offset: IndexSet) {
        offset.forEach{ index in
            let card = self.cards[index]
            self.managedObjectContext.delete(card)
        }
        saveContext()
    }
    
    func addCard(card: Card) {
        withAnimation{
            let newCard = CardInfo(context:managedObjectContext)
            newCard.question = card.question
            newCard.answer = card.answer
            newCard.languageCode = card.languageCode
            newCard.example = card.example
            newCard.type = card.type.rawValue
            saveContext()
        }
        
    }
    
    func modifyCard(card: Card, index: Int) {
        let newCard = cards[index]
        newCard.question = card.question
        newCard.answer = card.answer
        newCard.languageCode = card.languageCode
        newCard.example = card.example
        newCard.type = card.type.rawValue
        saveContext()
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}


//struct CardList_Previews: PreviewProvider {
//    static var previews: some View {
//        CardList().environmentObject(CardsPileViewModel())
//    }
//}
