//
//  CardListViewModel.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/17.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation
import SwiftUI

final class CardListViewModel:ObservableObject {
    var groups:[QuizCardGroup] {
        CardAdaptor.convertCardGroup(groups: self.cardGroups)
    }
    
    @Published var isShowEditor = false
    @Published var isDocumentPickerPresented = false
    @Published var showEditGroup = false
    @Published var searchText = ""
    @Published var showSearchbar = true
    @Published var isShowImportTips = false
    
    @Published var cardGroups:[CardGroup] = [CardGroup]()
    
    var searchedCards:[CardInfo] {
        CardInfo.searchedResult(question: searchText)
    }

    
    func onActionAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            if self.cardGroups.isEmpty {
                self.cardGroups = CardGroup.fetchResult
            }
            
            for index in self.cardGroups.indices {
                let _ = self.cardGroups[index].cardArray.map{
                    print("appear group:\(self.cardGroups[index].wrappedName) card:\($0.question!)")
                }
            }
        }
    }
    
    func fetchData() {
        self.cardGroups = CardGroup.fetchResult
    }
    
    func delete(index:Int, section:Int) {
        let card = self.cardGroups[section].cardArray[index]
        PersistenceController.shared.context.delete(card)
        PersistenceController.shared.saveContext()
    }
    
    func addCard(card: Card) {
        withAnimation{
            let newCard = CardInfo(context:PersistenceController.shared.context)
            newCard.question = card.question
            newCard.answer = card.answer
            newCard.languageCode = card.languageCode
            newCard.example = card.example
            newCard.type = card.type.rawValue
            newCard.weight = 0
            PersistenceController.shared.addCardIntoGroup(card: newCard, groupName: card.group)
        }
        
    }
    
    /// modify card information
    /// - Parameters:
    ///   - card: modified card model
    ///   - index: index of different lists
    ///   - section: if section is negetive, the list is search list
    func modifyCard(card: Card, index: Int, in section:Int) {
        
        var newCard:CardInfo
        if section >= 0 {
            newCard = cardGroups[section].cardArray[index]
        } else {
            newCard = searchedCards[index]
        }
 
        newCard.question = card.question
        newCard.answer = card.answer
        newCard.languageCode = card.languageCode
        newCard.example = card.example
        newCard.type = card.type.rawValue
        if newCard.ofGroup?.wrappedName == card.group {
            PersistenceController.shared.saveContext()
            return
        }
        if (newCard.ofGroup != nil) {
            newCard.ofGroup?.removeFromCards(newCard)
            
            PersistenceController.shared.addCardIntoGroup(card: newCard, groupName: card.group)
        } else {
            PersistenceController.shared.addCardIntoGroup(card: newCard, groupName: card.group)
        }
        
        PersistenceController.shared.saveContext()
    }
}
