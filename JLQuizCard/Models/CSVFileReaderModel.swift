//
//  CSVFileReaderModel.swift
//  JLQuizCard
//
//  Created by jack on 2021/3/20.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import CSV
import CoreData

class CSVFileReaderModel: ObservableObject {
    func readFileFromUrl(url:URL, importNewCards:@escaping ([Card]) -> Void ) -> Void {
        do {
            var importingCardData = [CardData]()
            let stream = InputStream(fileAtPath: url.path)!
            let csv = try! CSVReader(stream: stream, hasHeaderRow: true)
            let decoder = CSVRowDecoder()
            print("==>head row:\(String(describing: csv.headerRow))")
            while let row = csv.next() {
                print("==> \(row)")
                let card = try decoder.decode(CardData.self, from: csv)
                importingCardData.append(card)
            }
            print("import cards:\(importingCardData)")
            
            var importingCards = [Card]()
            for item in importingCardData {
                let card = Card(id: UUID(), question: item.question, answer: item.answer, example: item.example, languageCode: "de", type: .speech)
                importingCards.append(card)
            }
            importNewCards(importingCards)
        } catch {
            let nserror = error as NSError
            fatalError("decode error:\(nserror)")
        }
        
    }
    
}
