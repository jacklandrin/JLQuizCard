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
    @Published var isShowAlert = false
    @Published var errorMessage = "error"
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
                let card = Card(question: item.question,
                                answer: item.answer,
                                example: item.example,
                                languageCode: checkLanguageCode(code: item.langcode) ? item.langcode! : "en-GB",
                                type: .showText,
                                group:item.group)
                importingCards.append(card)
            }
            importNewCards(importingCards)
        } catch {
            let nserror = error as NSError
            errorMessage = nserror.description
            isShowAlert = true
        }
    }
    
    private func checkLanguageCode(code:String?) -> Bool {
        if let code = code, languageCodes.contains(code) {
            return true
        }
        return false
    }
    
}
