//
//  QuizCardGroup.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/23.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation
struct QuizCardGroup {
    var title:String
    var cards:[Card]
}

extension QuizCardGroup {
    static let mockGroup = QuizCardGroup(title: "mock", cards: [Card.previewCard])
}
