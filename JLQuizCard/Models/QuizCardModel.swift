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


class Card : ObservableObject,Identifiable  {

    @Published var question: String = ""
    @Published var answer: String = ""
    @Published var example: String = ""
    @Published var languageCode: String = "en-GB"
    @Published var type: CardType = .showText
    @Published var group: String = "default"
    var weight: Int = 0
    @Published var isTextMode = true
    {
        didSet {
            type = isTextMode ? .showText : .speech
        }
    }
    
    init(question:String,
         answer:String,
         example: String,
         languageCode: String,
         type:CardType) {
        self.question = question
        self.answer = answer
        self.example = example
        self.languageCode = languageCode
        self.type = type
    }
    
    convenience init(question:String,
                     answer:String,
                     example: String,
                     languageCode: String,
                     type:CardType,
                     weight:Int,
                     group:String) {
        self.init(question:question,
                  answer:answer,
                  example: example,
                  languageCode: languageCode,
                  type:type)
        self.group = group
        self.weight = weight
    }
    
    convenience init(question:String,
                     answer:String,
                     example: String,
                     languageCode: String,
                     type:CardType,
                     group:String) {
        self.init(question:question,
                  answer:answer,
                  example: example,
                  languageCode: languageCode,
                  type:type)
        self.group = group
    }
    
}

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
