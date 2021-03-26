//
//  CardEditor.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/6.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct CardEditor: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var isNewOne: Bool
    var card : CardInfo?
    @State var isMakingNewCard = false
    @State var isShowAlert: Bool = false
    @State private var languageCode = "en-GB"
    
    @State var sampleCard: Card = Card(question: "", answer: "", example: "", languageCode: "", type: .showText, weight: 0)
    
    var finishEditCard : (Card) -> Void
    
    init(isNewOne: Bool, card: CardInfo?, finishEditCard:@escaping (Card) -> Void) {
        self.isNewOne = isNewOne
        self.finishEditCard = finishEditCard
        self.card = card
    }
    
    func onAppearUpdateData() {
        guard self.isNewOne || (self.card != nil) else {
            return
        }
        
        if !isNewOne {
            self.sampleCard.isTextMode = (self.card?.type == CardType.showText.rawValue)
            self.sampleCard.question = self.card?.question ?? ""
            self.sampleCard.type = CardType(rawValue: self.card?.type ?? "showText") ?? .showText
            self.sampleCard.answer = self.card?.answer ?? ""
            self.sampleCard.example = self.card?.example ?? ""
            self.sampleCard.languageCode = card?.languageCode ?? "en-GB"
        }
    }
    
    var body: some View {
        VStack {
            QuizCard(onDragOut: {_ in}, sequence: 1)
                .environmentObject(sampleCard)
                .frame(minHeight:400)
                .padding(.top,-150)
                .padding(.horizontal,10)
            Spacer().frame(height:150)
            List{
                VStack(alignment:.leading) {
                    Toggle(isOn: self.$sampleCard.isTextMode.animation()) {
                        Text("Text Mode")
                    }
                    Text("Question:")
                    TextField("Write question here...", text: self.$sampleCard.question)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Example:")
                    TextField("Write example here...", text: self.$sampleCard.example)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Answer:")
                    TextField("Write answer here...", text: self.$sampleCard.answer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Please choose a language code")
                    Picker("Please choose a language code", selection:$sampleCard.languageCode) {
                        ForEach(Locale.preferredLanguages, id:\.self) {
                            Text($0)
                        }
                    }
                    Spacer()
                }
                
            }
        }
        .changeNavigationTitleAndTrailingButton(title: "Card Editor", trailingText: "Done", action: makeNewCard)
        .onAppear(perform: onAppearUpdateData)
        .onDisappear(perform: {
            if isMakingNewCard {
                let card = sampleCard
                self.finishEditCard(card)
            }
            
        })
        .padding(10.0)
            .alert(isPresented: self.$isShowAlert) {
        Alert(title: Text("Warning"), message: Text("Write something"), dismissButton: .default(Text("Got it!")))
        }
        
    }
    
    func makeNewCard() {
        guard self.sampleCard.question != "" else {
            self.isShowAlert = true
            return
        }
        
        guard self.sampleCard.example != "" else {
            self.isShowAlert = true
            return
        }
        
        guard self.sampleCard.answer != "" else {
            self.isShowAlert = true
            return
        }

        self.presentationMode.wrappedValue.dismiss()
        self.isMakingNewCard = true

    }
}

struct CardEditor_Previews: PreviewProvider {
    static var previews: some View {
        CardEditor(isNewOne: true, card: nil, finishEditCard: {_ in})
    }
}
