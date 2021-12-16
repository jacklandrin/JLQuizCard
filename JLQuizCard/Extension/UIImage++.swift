//
//  UIImage++.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/15.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import Intents
import IntentsUI

extension UIImage {
    var toINFile:INFile? {
        try? pngData()?
            .writeToUniqueTemporaryFile(contentType: .png)
            .toINFile
    }
}


extension UIImage {
    func textToImageLeft(drawText text: String,
                             fontSize:CGFloat,
                             textColor:UIColor = .black,
                             weight:UIFont.Weight = .medium,
                             atX x:CGFloat = 0,
                             atY y: CGFloat) -> UIImage {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.left
        textStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
            ] as [NSAttributedString.Key : Any]
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let width = self.size.width - 2 * x
        let textHeight = textFont.lineHeight
        let rect = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: textHeight))
        
        text.draw(with: rect, options:.usesLineFragmentOrigin,attributes: textFontAttributes, context:nil)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func drawLineOnImage(color:UIColor, from: CGPoint, to: CGPoint) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let context = UIGraphicsGetCurrentContext()
        guard let context = context else {
            return self
        }

        context.setLineWidth(1.0)
        context.setStrokeColor(color.cgColor)
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    func textToImageLeftMultiLine(drawText text: String,
                                  fontSize:CGFloat,
                                  textColor:UIColor = .black,
                                  weight:UIFont.Weight = .medium,
                                  atX x:CGFloat = 0,
                                  atY y: CGFloat) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.left
        textStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
            ] as [NSAttributedString.Key : Any]
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let width = self.size.width - 2 * x
        let lineBreaker = DefaultLineBreaker(attributedString: NSAttributedString(string: text, attributes: textFontAttributes))
        let lines = lineBreaker.breakTextToLines(maxLineWidth: width)
        let textHeight = textFont.lineHeight
        var currentY = y
        for line in lines {
            let lineRange = CTLineGetStringRange(line)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString = (text as NSString).substring(with: range)
            let rect = CGRect(origin: CGPoint(x: x, y: currentY), size: CGSize(width: width, height: textHeight))
            lineString.draw(in: rect, withAttributes:textFontAttributes)
            currentY += textHeight
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
  
    
   
}

