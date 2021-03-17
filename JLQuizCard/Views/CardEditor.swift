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
    @State var isTextMode:Bool = true
    @State var question: String = ""
    @State var answer: String = ""
    @State var example: String = ""
    @State var isShowAlert: Bool = false
    
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
            self.isTextMode = (self.card?.type == CardType.showText.rawValue)
            self.question = self.card?.question ?? ""
            self.answer = self.card?.answer ?? ""
        }
        return
    }
    
    var body: some View {
            VStack(alignment:.leading) {
                Toggle(isOn: self.$isTextMode.animation()) {
                    Text("Text Mode")
                }
                Text("Question:")
                TextField("Write question here...", text: self.$question)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Example:")
                TextField("Write example here...", text: self.$example)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Answer:")
                TextField("Write answer here...", text: self.$answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }.navigationBarTitle("Card Editor")
                .navigationBarItems(trailing: Button(action:makeNewCard){
                    Text("Done")
                })
                .onAppear(perform: onAppearUpdateData)
        .padding(10.0)
                .alert(isPresented: self.$isShowAlert) {
            Alert(title: Text("Warning"), message: Text("Write something"), dismissButton: .default(Text("Got it!")))
        }
    }
    
    func makeNewCard() {
        guard self.question != "" else {
            self.isShowAlert = true
            return
        }
        
        guard self.example != "" else {
            self.isShowAlert = true
            return
        }
        
        guard self.answer != "" else {
            self.isShowAlert = true
            return
        }
        
        let card = Card(question: self.question, answer: self.answer, example:self.example, languageCode:"en-US", type: self.isTextMode ? .showText : .speech)
        self.finishEditCard(card)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CardEditor_Previews: PreviewProvider {
    static var previews: some View {
        CardEditor(isNewOne: true, card: nil, finishEditCard: {_ in})
    }
}
