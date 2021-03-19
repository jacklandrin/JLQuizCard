//
//  QuizCardModel.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreData

let dragOutDistance = 240.0

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

enum CardType: String, Codable {
    case showText = "ShowText"
    case speech = "Speech"
}

struct Card : Codable, Identifiable, Hashable  {
    var id = UUID()
    var question: String
    var answer: String
    var example: String
    var languageCode: String
    var type: CardType

}

private let defaultCardPile:[Card] = [
    Card(question: "This is an English question.", answer: "Answer",example:"", languageCode:"en-US" ,type: .speech),
    Card(question: "What's your problem?", answer: "Answer",example:"", languageCode:"en-US" , type: .showText),
    Card(question: "Repeat,repeat,repeat!", answer: "Answer",example:"", languageCode:"en-US" , type: .speech),
    Card(question: "Come on! Try it again!", answer: "Answer",example:"", languageCode:"en-US" , type: .speech),
    Card(question: "Hello, world!", answer: "Answer",example:"", languageCode:"en-US" , type: .showText),
]


extension CardInfo {
    static var defaultFetchRequest:NSFetchRequest<CardInfo> {
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardInfo.id, ascending: true)]
        return request
    }
}

extension Card {
    static let previewCard = Card(question: "This is a English question.", answer: "Answer", example:"example", languageCode:"en-US" , type: .showText)
}

@propertyWrapper
struct UserDefaultValue<Value: Codable> {
    
    let key: String
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            let data = UserDefaults.standard.data(forKey: key)
            let value = data.flatMap { try? JSONDecoder().decode(Value.self, from: $0) }
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
