//
//  CardAdaptor.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/23.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation
struct CardAdaptor {
    static func convertCardGroup(groups:[CardGroup]) -> [QuizCardGroup] {
        groups.map{QuizCardGroup(title: $0.wrappedName, cards: convertCards(cards: $0.cardArray))}
    }
    
    static func convertCards(cards:[CardInfo]) -> [Card] {
        cards.map{convertCard(cardInfo: $0)}
    }
    
    static func convertCard(cardInfo:CardInfo) -> Card {
        return Card(question: cardInfo.question!,
                    answer: cardInfo.answer!,
                    example: cardInfo.example!,
                    languageCode: cardInfo.languageCode!,
                    type: CardType(rawValue: cardInfo.type!) ?? .speech,
                    weight: Int(cardInfo.weight),
                    group: "default")
    }
}
