//
//  WallpaperGenerator.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/15.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct DrawText {
    let question:String
    let answer:String
    let example:String
}

let WallpaperStyleKey = "WallpaperStyleKey"

class WallpaperGenerator {
    static let shared = WallpaperGenerator()

    var backgroundRect:CGRect
    let screenRect = UIScreen.main.bounds
    
    var currentStyle:WallpaperStyle {
        let userDefalts = UserDefaults(suiteName: appGroup)
        let styleStr = userDefalts?.string(forKey: WallpaperStyleKey)
        let style = WallpaperStyle(rawValue: styleStr ?? "Spring") ?? .spring
        return style
    }
    
    init() {
        let userDefalts = UserDefaults(suiteName: appGroup)
        let safeAreaBottom = userDefalts!.float(forKey: safeAreaBottomKey)
        let bottomSpace:CGFloat = CGFloat(130.0 + safeAreaBottom)
        let topSpace:CGFloat = safeAreaBottom > 0.0 ? 290 : 260
        backgroundRect = CGRect(x: 44, y: topSpace, width: screenRect.width - 88, height: screenRect.height - bottomSpace - topSpace)
    }
    
    func generate() -> UIImage? {
        let allCards = CardInfo.fetchResult
        let randomIndex = Int.random(in: 0..<allCards.count)
        let luckyCard = allCards[randomIndex]
        let question = luckyCard.question!
        let answer = luckyCard.answer!
        let example = luckyCard.example!
        let finalWallpaper = drawWallpaper(drawText: DrawText(question: question,
                                                              answer: answer,
                                                              example: example),
                                           config: currentStyle.configuration())
        return finalWallpaper
    }
    
    func drawWallpaper(drawText:DrawText, config:WallpaperStyleConfiguration) -> UIImage? {
        var finalCGImage:CGImage? = nil
        if let context = createContext(size: screenRect.size) {
            drawBackground(context: context, rect: screenRect, config: config)
            drawCardText(context:context, rect: screenRect, drawText: drawText, config: config)
            finalCGImage = context.makeImage()
        }
        guard let finalCGImage = finalCGImage else {
            return nil
        }

        let finalImage = UIImage(cgImage: finalCGImage)
        return finalImage
    }
    
    func drawBackground(context:CGContext, rect:CGRect, config:WallpaperStyleConfiguration) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = config.backgroundColors
        let colorLocations:[CGFloat] = [0.0, 0.5, 1.0]
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: rect.width, y: rect.height)
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.fillPath()
        drawStripe(context: context, rect: rect, config: config)
    }
    
    func drawStripe(context:CGContext, rect:CGRect, config:WallpaperStyleConfiguration) {
        let horizontalCount = Int(rect.width) / 40 + 1
        let verticalCount = Int(rect.height) / 40 + 1
        context.setFillColor(config.stripeColor)
        for index in 0..<horizontalCount {
            let stripeSize = CGSize(width: 20, height: rect.height)
            let stripeRect = CGRect(origin: CGPoint(x: index * 40, y: 0), size: stripeSize)
            context.fill(stripeRect)
        }
        
        for index in 0..<verticalCount {
            let stripeSize = CGSize(width: rect.width, height: 20)
            let stripeRect = CGRect(origin: CGPoint(x: 0, y: index * 40), size: stripeSize)
            context.fill(stripeRect)
        }
    }
    
    func drawTextBackground(context:CGContext, rect:CGRect, config:WallpaperStyleConfiguration) {
        let bgColor = config.textBackgroundColor
        context.setFillColor(bgColor)
        context.setAlpha(0.8)
        
        let path = CGPath(roundedRect: backgroundRect, cornerWidth: 20, cornerHeight: 20, transform: nil)
        context.addPath(path)
        context.fillPath()
    }
    
    func drawCardText(context:CGContext,
                      rect:CGRect,
                      drawText:DrawText,
                      config:WallpaperStyleConfiguration) {
        context.saveGState()
        context.translateBy(x: screenRect.origin.x,
                            y: screenRect.origin.y + screenRect.size.height)
        context.scaleBy(x: 1, y: -1)
        UIGraphicsPushContext(context)
        
        drawTextBackground(context: context, rect: screenRect, config: config)
        let text_X = backgroundRect.origin.x + 10
        var currentY = drawText.question.textToImageLeftMultiLine(fontSize: 20,
                                                                  textColor: config.mainTextColor,
                                                                  weight:.bold,
                                                                   atX: text_X,
                                                                   atY: backgroundRect.origin.y + 20,
                                                                   size: screenRect.size)
        
        currentY = drawText.answer.textToImageLeftMultiLine(fontSize: 18,
                                                            textColor: config.secondaryTextColor,
                                                             atX: text_X,
                                                             atY: currentY + 10,
                                                             size: screenRect.size)
        drawALine(context: context,
                  rect: screenRect,
                  atX: text_X,
                  atY: currentY + 10,
                  config: config)
        
        currentY = drawText.example.textToImageLeftMultiLine(fontSize: 18,
                                                             textColor: config.secondaryTextColor,
                                                             atX: text_X,
                                                             atY: currentY + 20,
                                                             size: screenRect.size)
        
        UIGraphicsPopContext()
        context.restoreGState()
    }
    
    func drawALine(context:CGContext, rect:CGRect, atX:CGFloat, atY:CGFloat, config:WallpaperStyleConfiguration) {
        
        context.setLineWidth(2.0)
        context.setStrokeColor(config.stripeColor)
        context.move(to: CGPoint(x: atX, y: atY))
        context.addLine(to: CGPoint(x: rect.width - atX, y: atY))
        context.strokePath()
    }
    
    private func createContext(size: CGSize) -> CGContext? {
        return CGContext(data: nil,
                         width: Int(size.width),
                         height: Int(size.height),
                         bitsPerComponent: 8,
                         bytesPerRow: 0,
                         space: CGColorSpaceCreateDeviceRGB(),
                         bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
    }
}
