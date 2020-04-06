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
    
    public let card : Card
    let onDragOut:(CGFloat) -> Void
    @State var zRotation: Angle = .degrees(0.0)
//    @State var opacity: Double = 1.0
//    @State var hasDraggedback:Bool = false
    let sequence: Int
    
    var body: some View {
        FlipView (
            CardSide{
                VStack {
                    Text("Qusetion:\(sequence)")
                        .font(Font.system(size: 20.0, design: .rounded))
                    Spacer().frame(height:30)
                    if card.type == .showText {
                        Text(card.question)
                    }
                    else {
                        Button("🗣") {
                            let utterance = AVSpeechUtterance(string: self.card.question)
                            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                            utterance.rate = 0.5

                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(utterance)
                        }
                    }
                }
                
            },
            CardSide {
                VStack {
                    Text("Answer:\(sequence)")
                        .font(Font.system(size: 20.0, design: .rounded))
                    Spacer().frame(height:30)
                    Text((card.type == .showText) ? card.answer : card.question)
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
                            print("dragDistance:\(dragDistance)")
                        let validRange = Double(dragDistance) / dragOutDistance
                            if abs(dragDistance) < 1000   {
                                if abs(validRange) > 1 {
                                    self.onDragOut(dragDistance)
                                } else if validRange > 0{
                                    self.zRotation = .degrees(validRange * 90.0)
                                }
                            }
                    
                    }
                .onEnded{ _ in
                    withAnimation{
                        self.zRotation = .degrees(0.0)
                    }
                }
            )
    }
}


struct QuizCard_Previews: PreviewProvider {
    static var previews: some View {
        QuizCard(card: Card.previewCard, onDragOut: {_ in}, sequence: 1 )
    }
}


