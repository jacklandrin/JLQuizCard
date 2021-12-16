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

class Card : ObservableObject,Identifiable  {
//    var id = UUID()
    @Published var question: String = ""
    @Published var answer: String = ""
    @Published var example: String = ""
    @Published var languageCode: String = ""
    @Published var type: CardType = .showText
    @Published var group: String = ""
    var weight: Int = 0
    @Published var isTextMode = true
    {
        didSet {
            type = isTextMode ? .showText : .speech
        }
    }
    
    init(question:String, answer:String, example: String, languageCode: String, type:CardType) {
        self.question = question
        self.answer = answer
        self.example = example
        self.languageCode = languageCode
        self.type = type
    }
    
    convenience init(question:String, answer:String, example: String, languageCode: String, type:CardType, weight:Int) {
        self.init(question:question, answer:answer, example: example, languageCode: languageCode, type:type)
        self.weight = weight
    }
    
    convenience init(question:String, answer:String, example: String, languageCode: String, type:CardType, group:String) {
        self.init(question:question, answer:answer, example: example, languageCode: languageCode, type:type)
        self.group = group
    }
    
   static func convertCard(cardInfo:CardInfo) -> Card {
    return Card(question: cardInfo.question!, answer: cardInfo.answer!, example: cardInfo.example!, languageCode: cardInfo.languageCode!, type: CardType(rawValue: cardInfo.type!) ?? .speech, weight: Int(cardInfo.weight))
    }
}

struct CardData: Decodable {
    var question: String
    var answer: String
    var example: String
    var group: String
}

private let defaultCardPile:[Card] = [
    Card(question: "This is an English question.", answer: "Answer",example:"", languageCode:"en-US" ,type: .speech),
    Card(question: "What's your problem?", answer: "Answer",example:"", languageCode:"en-US" , type: .showText),
    Card(question: "Repeat,repeat,repeat!", answer: "Answer",example:"", languageCode:"en-US" , type: .speech),
    Card(question: "Come on! Try it again!", answer: "Answer",example:"", languageCode:"en-US" , type: .speech),
    Card(question: "Hello, world!", answer: "Answer",example:"", languageCode:"en-US" , type: .showText),
]


extension Card {
    static let previewCard = Card(question: "This is a English question.", answer: "Answer", example:"example", languageCode:"en-US" , type: .showText)
}

class CardPileViewModel: ObservableObject {
    var groupNames:[String] {
        CardGroup.fetchResult.map{$0.wrappedName}
    }
    
    var currentGroupIndex : Int = CardGroup.fetchResult.indices.filter{CardGroup.fetchResult[$0].showing == true}.first ?? 0
    {
        didSet {
            for group in CardGroup.fetchResult {
                group.showing = false
            }
            CardGroup.fetchResult[currentGroupIndex].showing = true
            
            func saveContext() {
                PersistenceController.shared.saveContext()
            }
        }
        
    }
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
