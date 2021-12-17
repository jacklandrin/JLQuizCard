//
//  TTSManager.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/16.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import AVFoundation

class TTSManager{
    static let share = TTSManager()
    var synthesizer = AVSpeechSynthesizer()
}
