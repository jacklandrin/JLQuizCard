//
//  String++.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/16.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

extension String{

    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    
    func countOf(subString:String) -> Int {
        return self.components(separatedBy: subString).count
    }
    
    func textToImageLeftMultiLine(fontSize:CGFloat,
                                  textColor:UIColor = .black,
                                  weight:UIFont.Weight = .medium,
                                  atX x:CGFloat = 0,
                                  atY y: CGFloat,
                                  size:CGSize) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.left
        textStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
            ] as [NSAttributedString.Key : Any]
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let width = size.width - 2 * x
        let lineBreaker = DefaultLineBreaker(attributedString: NSAttributedString(string: self, attributes: textFontAttributes))
        let lines = lineBreaker.breakTextToLines(maxLineWidth: width)
        let textHeight = textFont.lineHeight
        var currentY = y
        for line in lines {
            let lineRange = CTLineGetStringRange(line)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString = (self as NSString).substring(with: range)
            let realLineCount = lineString.countOf(subString: "\r")
            let realTextHeight = CGFloat(realLineCount) * textHeight
            let rect = CGRect(origin: CGPoint(x: x, y: currentY), size: CGSize(width: width, height: realTextHeight))
            lineString.draw(in: rect, withAttributes:textFontAttributes)
            currentY += realTextHeight
        }
        return currentY
    }
    
    func textToImageLeft(drawText text: String,
                             fontSize:CGFloat,
                             textColor:UIColor = .black,
                             weight:UIFont.Weight = .medium,
                             atX x:CGFloat = 0,
                             atY y: CGFloat,
                             size:CGSize) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.left
        textStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
            ] as [NSAttributedString.Key : Any]
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let width = size.width - 2 * x
        let textHeight = textFont.lineHeight
        let rect = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: textHeight))
        
        text.draw(with: rect, options:.usesLineFragmentOrigin,attributes: textFontAttributes, context:nil)
        
        return y + textHeight
    }
}
