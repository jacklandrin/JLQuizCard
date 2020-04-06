//
//  ContentView.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var textContent: String = "Hello, world!"
    var body: some View {
        Text(textContent).onTapGesture {
            let utterance = AVSpeechUtterance(string: self.textContent)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.55

            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
