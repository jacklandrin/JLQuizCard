//
//  DefaultLineBreaker.swift
//  TextDrawing
//
//  Created by Dominik Olędzki on 17/01/2017.
//  Copyright © 2017 Dominik Oledzki.
//

import CoreText
import UIKit

class DefaultLineBreaker: LineBreaker {
    
    private let attributedString: NSAttributedString
    private let typesetter: CTTypesetter
    private let unbrokenLine: CTLine
    
    
    required init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
        self.typesetter = CTTypesetterCreateWithAttributedString(attributedString)
        self.unbrokenLine = CTTypesetterCreateLine(typesetter, CFRangeMake(0, 0))
    }
    
    func breakTextToLines(maxLineWidth width: CGFloat) -> [CTLine] {
        var result: [CTLine] = []
        
        let glyphsCount = getGlyphsCount()
        let glyphsPositions = getGlyphsPositions()
        let glyphsAdvances = getGlyphsAdvances()
        let glyphsIndices = getGlyphsIndices()
        let potentialLineBreaks = attributedString.string.getPotentialLineBreaks()

        // Find the first glyph which does not fit in frame
        var glyphIndex = 0
        var cumulatedWidth: CGFloat = 0.0
        var lastLineRange = CFRangeMake(0, 0)
        
        while glyphIndex < glyphsCount {
            
            while
                glyphIndex < glyphsCount &&
                    glyphsPositions[glyphIndex] + glyphsAdvances[glyphIndex] - cumulatedWidth <= width {
                        glyphIndex += 1
            }
            
            let lineStart = lastLineRange.location + lastLineRange.length
            let lineLength: Int
            
            if glyphIndex < glyphsCount {
                let characterIndex = glyphsIndices[glyphIndex]
                
                // find closest preceding line break
                let lineBreak = potentialLineBreaks.last { (index) -> Bool in
                    return index <= characterIndex
                    }!
                lineLength = lineBreak - lineStart
                
                let breakGlyphIndex = glyphsIndices.enumerated().last(where: { (_, element) -> Bool in
                    return element <= lineBreak
                })!.offset
                
                cumulatedWidth = glyphsPositions[breakGlyphIndex]
            } else {
                lineLength = 0
            }
         
            
            let lineRange = CFRangeMake(lineStart, lineLength)
            lastLineRange = lineRange
            let line = CTTypesetterCreateLine(typesetter, lineRange)
            result.append(line)
        }
        
        return result
    }
    
    private func getGlyphsPositions() -> [CGFloat] {
        var positions = [CGFloat]()
        for run in CTLineGetGlyphRuns(unbrokenLine) as! [CTRun] {
            let glyphsCount = CTRunGetGlyphCount(run)
            var runPositions = [CGPoint](repeating: CGPoint.nan, count: glyphsCount)
            CTRunGetPositions(run, CFRangeMake(0, 0), &runPositions)
            positions += runPositions.map { $0.x }
        }
        return positions
    }
    
    private func getGlyphsIndices() -> [CFIndex] {
        var indices = [CFIndex]()
        for run in CTLineGetGlyphRuns(unbrokenLine) as! [CTRun] {
            let glyphsCount = CTRunGetGlyphCount(run)
            var runIndices = [CFIndex](repeating: -1, count: glyphsCount)
            CTRunGetStringIndices(run, CFRangeMake(0, 0), &runIndices)
            indices += runIndices
        }
        return indices
    }
    
    private func getGlyphsAdvances() -> [CGFloat] {
        var advances = [CGFloat]()
        for run in CTLineGetGlyphRuns(unbrokenLine) as! [CTRun] {
            let glyphsCount = CTRunGetGlyphCount(run)
            var runAdvances = [CGSize](repeating: CGSize.zero, count: glyphsCount)
            CTRunGetAdvances(run, CFRangeMake(0, 0), &runAdvances)
            advances += runAdvances.map { $0.width }
        }
        return advances
    }
    
    private func getGlyphsCount() -> CFIndex {
        return CTLineGetGlyphCount(unbrokenLine)
    }
}
