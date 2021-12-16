//
//  Sequence+Extensions.swift
//  TextDrawing
//
//  Created by Dominik Olędzki on 04/02/2017.
//  Copyright © 2017 Dominik Oledzki. All rights reserved.
//

import Foundation

extension Sequence {
    func last(where predicate: (Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {
        var lastPassingElement: Iterator.Element? = nil
        for x in self {
            if try predicate(x) {
                lastPassingElement = x
            } else {
                break
            }
        }
        
        return lastPassingElement
    }
}
