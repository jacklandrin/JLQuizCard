//
//  CardEditorViewModel.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/16.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation

@MainActor
final class CardEditorViewModel:ObservableObject {
    @Published var isMakingNewCard = false
    @Published var isShowAlert: Bool = false
    @Published var languageCode = "en-GB"
    
    @Published var sampleCard: Card = Card(question: "",
                                       answer: "",
                                       example: "",
                                       languageCode: "en-GB",
                                       type: .showText,
                                       weight: 0)
    @Published var groups:[CardGroup] = [CardGroup]()
    
    var isNewOne: Bool
    var card : CardInfo?
    
    init(isNewOne: Bool, card: CardInfo?) {
        self.isNewOne = isNewOne
        self.card = card
    }
    
    func setupGroups() {
        groups = CardGroup.fetchResult
    }
    
    
}
