//
//  MyLabel.swift
//  TextDrawing
//
//  Created by Dominik Olędzki on 28/12/2016.
//  Copyright © 2016 Dominik Oledzki.
//

import UIKit
import CoreGraphics
import CoreText

class MyLabel: UIView {

    var attributedText: NSAttributedString? {
        didSet {
            if let attributedText = attributedText {
                lineBreaker = lineBreakerProvider(attributedText)
            } else {
                lineBreaker = nil
            }
        }
    }
    
    private var lineBreaker: LineBreaker?
    var lineBreakerProvider = {
        (attributedString: NSAttributedString) -> LineBreaker in
        return DefaultLineBreaker(attributedString: attributedString)
    }
    
    override func draw(_ rect: CGRect) {
        if let text = attributedText {
            let lines = breakTextToLines(text)
            draw(lines)
        }
    }
    
    func breakTextToLines(_ text: NSAttributedString) -> [CTLine] {
        guard let lineBreaker = lineBreaker else {
            return []
        }
        return lineBreaker.breakTextToLines(maxLineWidth: bounds.width)
    }
    
    func draw(_ lines: [CTLine]) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        flipCoordinates(ctx)
        resetTextPosition(ctx)
        
        for line in lines {
            let lineBounds = CTLineGetBoundsWithOptions(line, [])
            let lastLinePosition = ctx.textPosition.y
            ctx.textPosition.x = 0.0
            // Move lower for 1 line height but maintaining alignment to the line origin (baseline)
            ctx.textPosition.y = lastLinePosition - lineBounds.height - lineBounds.origin.y
            ctx.textPosition.y = floor(ctx.textPosition.y + 0.5)
            CTLineDraw(line, ctx)
            // Compensate previous move, now text position is below text, not at the origin.
            ctx.textPosition.y += lineBounds.origin.y
        }
    }
    
    func flipCoordinates(_ ctx: CGContext) {
        ctx.translateBy(x: 0.0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
    }
    
    func resetTextPosition(_ ctx: CGContext) {
        ctx.textPosition = CGPoint(x: 0.0, y: bounds.height)
    }
}
