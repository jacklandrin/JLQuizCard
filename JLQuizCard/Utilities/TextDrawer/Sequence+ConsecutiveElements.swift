//
//  Sequence+ConsecutiveElements.swift
//
//  Created by Dominik Olędzki on 23/01/2017.
//  Copyright © 2017 Dominik Olędzki.
//  This software is published under MIT license https://opensource.org/licenses/mit-license.php
//

import Foundation

extension Sequence {
    /**
     You can use this method to access sequence by n consecutive elements, starting from each element.
     For example, the following code `Array((0..<4).takeElements(by: 2))` will result in array like that:
     `[[0, 1], [1, 2], [2, 3]]`
     
     - Parameter by: number of elements taken from original sequence to form one element of new sequence
     - Returns: Sequence of arrays, where each array contains `n` elements from original sequence
     */
    func takeElements(by n: Int) -> ConsecutiveElementsSequence<Self> {
        return ConsecutiveElementsSequence(originSequence: self, takenElementsCount: n)
    }
}

struct ConsecutiveElementsSequence<OriginSequence: Sequence>: Sequence {
    typealias OriginIterator = OriginSequence.Iterator
    typealias Iterator = ConsecutiveElementsIterator<OriginIterator>
    
    let originSequence: OriginSequence
    let takenElementsCount: Int
    
    func makeIterator() -> ConsecutiveElementsIterator<OriginSequence.Iterator> {
        return ConsecutiveElementsIterator(iterator: originSequence.makeIterator(), takeBy: takenElementsCount)
    }
    
}

struct ConsecutiveElementsIterator<OriginIterator: IteratorProtocol>: IteratorProtocol {
    typealias OriginElement = OriginIterator.Element
    typealias Element = [OriginElement]
    var previousElements: [OriginElement] = []
    var originIterator: OriginIterator
    let takenElementsCount: Int
    
    init(iterator: OriginIterator, takeBy n: Int) {
        takenElementsCount = n
        originIterator = iterator
        
        while previousElements.count < takenElementsCount {
            if let nextElement = originIterator.next() {
                previousElements.append(nextElement)
            } else {
                break
            }
        }
    }
    
    mutating func next() -> Element? {
        guard previousElements.count == takenElementsCount else {
            return nil
        }
        
        let current = previousElements
        previousElements.removeFirst()
        if let newElement = originIterator.next() {
            previousElements.append(newElement)
        }
        
        return current
    }
}
