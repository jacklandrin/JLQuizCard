//
//  WallpaperGenerator.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/15.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

class WallpaperGenerator {
    static let shared = WallpaperGenerator()
    func generate() -> UIImage {
        let allCards = CardInfo.fetchResult
        let randomIndex = Int.random(in: 0..<allCards.count)
        let luckyCard = allCards[randomIndex]
        let question = luckyCard.question!
        let answer = luckyCard.answer!
        let example = luckyCard.example!
        let wallpaperBg = UIImage(named: "Cat_b")!
        let wallpaperWithQuestion = wallpaperBg
            .textToImageLeft(drawText: question,
                                     fontSize: 16,
                                     textColor: UIColor(named: "Cat_q")!,
                                     weight: .bold,
                                     atX: 44,
                                     atY: 290)
        let wallpaperWithAnswer = wallpaperWithQuestion
            .textToImageLeft(drawText: answer,
                             fontSize: 14,
                             textColor: UIColor(named: "Cat_a")!,
                             weight: .regular,
                             atX: 44,
                             atY: 320)
        
        let wallpaperWithLine = wallpaperWithAnswer
            .drawLineOnImage(color: UIColor(named: "Cat_q")!,
                             from: CGPoint(x: 44, y: 370),
                             to: CGPoint(x: wallpaperWithAnswer.size.width - 44, y: 370))
        
        let finalWallpaper = wallpaperWithLine
            .textToImageLeftMultiLine(drawText: "Example:\r\(example)",
                             fontSize: 14,
                             textColor: UIColor(named: "Cat_e")!,
                             weight: .regular,
                             atX: 44,
                             atY: 380)
        return finalWallpaper
    }
}
