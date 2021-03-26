//
//  QuizCard.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI
import AVFoundation

struct QuizCard: View {
    
    @EnvironmentObject var card : Card
    let onDragOut:(CGFloat) -> Void
    @State var zRotation: Angle = .degrees(0.0)
    let sequence: Int
    
    init(onDragOut:@escaping (CGFloat) -> Void, sequence:Int) {
        self.onDragOut = onDragOut
        self.sequence = sequence
    }
    
    
    var body: some View {
        FlipView (
            CardSide{
                VStack {
                    Text("Qusetion:\(sequence)")
                        .font(Font.system(size: 20.0, design: .rounded))
                    Spacer().frame(height:30)
                    if card.type == .showText {
                        Text(card.question == "" ? "This is a Question." : card.question)
                    }
                    else {
                        Button("🗣") {
                            let utterance = AVSpeechUtterance(string: self.card.question)
                            utterance.voice = AVSpeechSynthesisVoice(language: card.languageCode)
                            utterance.rate = 0.5

                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(utterance)
                        }
                    }
                    Spacer().frame(height:20)
                    Text(card.example == "" ? "This is an Example." : card.example)
                        .font(Font.system(size: 24.0, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
            },
            CardSide {
                VStack {
                    Text("Answer:\(sequence)")
                        .font(Font.system(size: 20.0, design: .rounded))
                    Spacer().frame(height:30)
                    Text(card.answer == "" ? "This is an Answer." : card.answer)
                }
            }
        )
        .rotation3DEffect(
            zRotation,
            axis: (1.0, 0.0, 0.0),
            anchor: .init(x: 0.5, y: 1.5),
            perspective: 0.1
        )
        .gesture(DragGesture()
                .onChanged {gesture in
                        let dragDistance = gesture.translation.height
                        let validRange = Double(dragDistance) / dragOutDistance
                            if abs(dragDistance) < 1000   {
                                if abs(validRange) < 1 && validRange > 0{
                                    self.zRotation = .degrees(validRange * -90.0)
                                }
                            }
                    }
                .onEnded{ gesture in
                    let dragDistance = gesture.translation.height
                    let validRange = Double(dragDistance) / dragOutDistance
                    if abs(dragDistance) < 1000   {
                        if abs(validRange) > 1 {
                            self.onDragOut(dragDistance)
                        }
                    }
                    withAnimation{
                        self.zRotation = .degrees(0.0)
                    }
                }
            )
    }
}


struct QuizCard_Previews: PreviewProvider {
    static var previews: some View {
        QuizCard(onDragOut: {_ in}, sequence: 1 ).environmentObject(Card.previewCard)
    }
}


