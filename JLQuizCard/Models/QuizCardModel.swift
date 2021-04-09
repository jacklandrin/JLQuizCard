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


extension CardInfo {
    
    static var defaultFetchRequest:NSFetchRequest<CardInfo> {
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardInfo.weight, ascending: false)]
        print("fetched the cards")
        return request
    }
    
    static func searchFetchRequest(question:String) -> NSFetchRequest<CardInfo> {
        let request: NSFetchRequest<CardInfo> = CardInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardInfo.weight, ascending: false)]
        request.predicate = NSPredicate(format: "question CONTAINS %@", question)
        print("fetched the searched cards")
        return request
    }
    
    static func searchedResult(question:String) -> [CardInfo] {
        do {
            let fetchResults = try SceneDelegate.persistenContainer.viewContext.fetch(CardInfo.searchFetchRequest(question: question))
            if  fetchResults.count > 0 {
                return fetchResults
            }
        } catch {
            
        }
        return [CardInfo]()
    }
}

extension CardGroup {
    static var defaultFetchRequest:NSFetchRequest<CardGroup> {
        let request: NSFetchRequest<CardGroup> = CardGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardGroup.groupname, ascending: true)]
        print("fetched the card group")
        return request
    }
    
    static var fetchResult: [CardGroup] {
        do {
            let fetchResults = try SceneDelegate.persistenContainer.viewContext.fetch(CardGroup.defaultFetchRequest)
            if  fetchResults.count > 0 {
                return fetchResults
            }
        } catch {
            
        }
        return [CardGroup]()
    }
    
    public var cardArray:[CardInfo] {
        let set = cards as? Set<CardInfo> ?? []
        let array = set.sorted{
            ($0.weight, $0.id) > ($1.weight, $1.id)
        }
        return array
    }
    
    public var wrappedName:String {
        groupname ?? "default group"
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
              do {
                try SceneDelegate.persistenContainer.viewContext.save()
              } catch {
                print("Error saving managed object context: \(error)")
              }
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
