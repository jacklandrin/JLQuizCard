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
                ForEach(cards.indices, id:\.id) { i in
                    NavigationLink(destination: CardEditor(isNewOne: false, card: cards[i], finishEditCard: { c in
                            self.modifyCard(card: c, index: i)
                        })){
                           Text(cellText(card: cards[i]))
                    }

                }.onDelete(perform: delete)
            
            }.changeNavigationTitleAndTrailingLink(title: "Card List", destination:CardEditor(isNewOne: true, card: nil, finishEditCard: { c in
                                    self.addCard(card: c)
            })
            , trailingText:"Add")
        
    }
    
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

        let newCard = CardInfo(context:managedObjectContext)
        newCard.question = card.question
        newCard.answer = card.answer
        newCard.languageCode = card.languageCode
        newCard.example = card.example
        newCard.type = card.type.rawValue
        saveContext()
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


struct CardList_Previews: PreviewProvider {
    static var previews: some View {
        CardList().environmentObject(CardsPileViewModel())
    }
}
