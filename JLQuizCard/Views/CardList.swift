//
//  CardList.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/6.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import Foundation

struct CardList: View {
    @EnvironmentObject var cardPileViewModel: CardsPileViewModel
    
    var body: some View {
            List {
                ForEach(self.cardPileViewModel.pile.indices, id: \.id) { i in
                    NavigationLink(destination:
                                    CardEditor(isNewOne: false, card: self.cardPileViewModel.pile[i], finishEditCard: { c in
                                        self.modifyCard(card: c, index: i)
                                    }))
                    {
                        Text(self.cellText(card: self.cardPileViewModel.pile[i]))
                    }
                }.onDelete(perform: delete)
                
            }.changeNavigationTitleAndTrailingLink(title: "Card List", destination:CardEditor(isNewOne: true, card: nil, finishEditCard: { c in
                                    self.addCard(card: c)
            })
            , trailingText:"Add")
        
    }
    
    func cellText(card: Card) -> String {
        let prefix = (card.type == .speech) ? "🗣:" : "Text:"
        return prefix + card.question
    }
    
    func delete(at offset: IndexSet) {
        self.cardPileViewModel.deleteCard(at: offset.first!)
    }
    
    func addCard(card: Card) {
        self.cardPileViewModel.addCard(card: card)
    }
    
    func modifyCard(card: Card, index: Int) {
        self.cardPileViewModel.modifyCard(card: card, index: index)
    }
}


struct CardList_Previews: PreviewProvider {
    static var previews: some View {
        CardList().environmentObject(CardsPileViewModel())
    }
}
