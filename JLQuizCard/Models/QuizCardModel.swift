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

let dragOutDistance = 240.0

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

struct Card : Codable, Identifiable, Hashable  {
    var id = UUID()
    var question: String
    var answer: String
    var type: CardType
    
    enum CardType: String, Codable {
        case showText = "ShowText"
        case speech = "Speech"
    }

}

private let defaultCardPile:[Card] = [
    Card(question: "This is an English question.", answer: "Answer", type: .speech),
    Card(question: "What's your problem?", answer: "Answer", type: .showText),
    Card(question: "Repeat,repeat,repeat!", answer: "Answer", type: .speech),
    Card(question: "Come on! Try it again!", answer: "Answer", type: .speech),
    Card(question: "Hello, world!", answer: "Answer", type: .showText),
]

class CardsPileViewModel: ObservableObject, Identifiable {
    
    let objectWillChange = PassthroughSubject<CardsPileViewModel, Never>()
    
    @UserDefaultValue(key: "pile", defaultValue: defaultCardPile)
    var pile:[Card] {
        didSet{
            objectWillChange.send(self)
        }
    }
    
    @UserDefaultValue(key: "title", defaultValue: "Ready? Let's review!")
    var title : String //= "Ready? Let's review!"
    
    func deleteCard(at: Int) {
        self.pile.remove(at: at)
        objectWillChange.send(self)
    }
    
    func addCard(card: Card) {
        self.pile.append(card)
        objectWillChange.send(self)
    }
    
    func modifyCard(card: Card, index: Int) {
        self.pile[index] = card
        objectWillChange.send(self)
        
    }
}

extension Card {
    static let previewCard = Card(question: "This is a English question.", answer: "Answer", type: .showText)
//    static let previewCard = Card(question: "This is a English question.", answer: "Answer", type: .speech)
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
