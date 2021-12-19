//
//  DefaultCards.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/19.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation

struct CardData: Decodable {
    var question: String
    var answer: String
    var example: String
    var group: String
}

let defaultCardPile:[CardData] = [
    CardData(question: "This is an English question.", answer: "Answer",example:"example", group: "My Group"),
    CardData(question: "What's your problem?", answer: "Answer",example:"example", group: "My Group"),
    CardData(question: "Repeat,repeat,repeat!", answer: "Answer",example:"example", group: "My Group"),
    CardData(question: "Come on! Try it again!", answer: "Answer",example:"example", group: "My Group"),
    CardData(question: "Hello, world!", answer: "Answer",example:"", group: "My Group"),
]
