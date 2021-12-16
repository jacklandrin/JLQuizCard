//
//  String+LineBreaks.swift
//  TextDrawing
//
//  Created by Dominik Olędzki on 06/01/2017.
//  Copyright © 2017 Dominik Oledzki.
//

import Foundation

extension String {
    func getPotentialLineBreaks() -> [Int] {
        var result = [Int]()
        for (i, pair) in self.takeElements(by: 2).enumerated() {
            if pair[0] == " " && pair[1] != " " {
                result.append(i + 1)    // break possibility after space, this way you can draw a space at the end of the line without changing the string (because whitespace is not pritable anyways)
            }
        }
        result.append(self.count)
        return result
    }
}
