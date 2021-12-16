//
//  SystemLineBreaker.swift
//  TextDrawing
//
//  Created by Dominik Olędzki on 04/02/2017.
//  Copyright © 2017 Dominik Oledzki. All rights reserved.
//

import Foundation
import CoreText

class SystemLineBreaker: LineBreaker {
    private let attributedString: NSAttributedString
    private let typesetter: CTTypesetter
    private let stringLength: Int
    
    required init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
        self.typesetter = CTTypesetterCreateWithAttributedString(attributedString)
        self.stringLength = attributedString.length
    }
    
    func breakTextToLines(maxLineWidth: CGFloat) -> [CTLine] {
        var results: [CTLine] = []
        var start: CFIndex = 0
        while start < stringLength {
            let lineLenght = CTTypesetterSuggestLineBreak(typesetter, start, Double(maxLineWidth))
            let range = CFRangeMake(start, lineLenght)
            let line = CTTypesetterCreateLine(typesetter, range)
            results.append(line)
            start += lineLenght
        }
        return results
    }
}

