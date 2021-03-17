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
    @EnvironmentObject var cardPileViewModel: CardsPileViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: CardInfo.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \CardInfo.id, ascending: true)
        ]
    ) var cards: FetchedResults<CardInfo>
    
    var body: some View {
            List {
//                ForEach(self.cardPileViewModel.pile.indices, id: \.id) { i in
//                    NavigationLink(destination:
//                        CardEditor(isNewOne: false, card: self.cardPileViewModel.pile[i], finishEditCard: { c in
//                            self.modifyCard(card: c, index: i)
//                        }))
//                    {
//                        Text(self.cellText(card: self.cardPileViewModel.pile[i]))
//                    }
//                }.onDelete(perform: delete)
                ForEach(cards.indices, id:\.id) { i in
                    NavigationLink(destination: CardEditor(isNewOne: false, card: cards[i], finishEditCard: { c in
                            self.modifyCard(card: c, index: i)
                        }))
                    {
                           Text(cellText(card: cards[i]))
                    }
                }
            }.navigationBarTitle(Text("Card List"))
            .navigationBarItems(trailing: NavigationLink(destination: 
                CardEditor(isNewOne: true, card: nil, finishEditCard: { c in
                    self.addCard(card: c)
                }))
            {
                Text("Add")
            })
    }
    
    func cellText(card: CardInfo) -> String {
        let prefix = (card.type == CardType.speech.rawValue) ? "🗣:" : "Text:"
        return prefix + card.question!
    }
    
    func delete(at offset: IndexSet) {
//        self.cardPileViewModel.deleteCard(at: offset.first!)
        offset.forEach{ index in
            let card = self.cards[index]
            self.managedObjectContext.delete(card)
        }
        saveContext()
    }
    
    func addCard(card: Card) {
//        self.cardPileViewModel.addCard(card: card)
        let newCard = CardInfo(context:managedObjectContext)
        newCard.question = card.question
        newCard.answer = card.answer
        newCard.languageCode = card.languageCode
        newCard.example = card.example
        newCard.type = card.type.rawValue
        saveContext()
    }
    
    func modifyCard(card: Card, index: Int) {
//        self.cardPileViewModel.modifyCard(card: card, index: index)
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


struct CardList_Previews: PreviewProvider {
    static var previews: some View {
        CardList().environmentObject(CardsPileViewModel())
    }
}
