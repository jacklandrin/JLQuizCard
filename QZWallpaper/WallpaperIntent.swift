//
//  WallpaperIntent.swift
//  JLQuizCardIntentExtension
//
//  Created by Jacklandrin on 2021/12/15.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import Intents
import UIKit

@MainActor
final class WallpaperIntentHandler:NSObject, QuizCardWallpaperIntentHandling {
    func handle(intent: QuizCardWallpaperIntent) async -> QuizCardWallpaperIntentResponse {
        let response = QuizCardWallpaperIntentResponse(code: .success, userActivity: nil)
        response.wallpaper = WallpaperGenerator.shared.generate()?.toINFile
        return response
    }
}
