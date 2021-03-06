//
//  CardEditor.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/6.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct CardEditor: View {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var isPortrait : Bool { UIDevice.current.orientation.isPortrait }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    var isNewOne: Bool
    var card : CardInfo?
    @State var isMakingNewCard = false
    @State var isShowAlert: Bool = false
    @State var languageCode = "en-GB"
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
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
            self.sampleCard.group = card?.ofGroup?.groupname ?? ""
        }
    }
    
    var body: some View {
        
        VStack {
            QuizCard(onDragOut: {_ in}, sequence: 1)
                .environmentObject(sampleCard)
                .frame(height:self.keyboardHeightHelper.isShowingKeyboard ? 300 : 400)
                .padding(.top, self.keyboardHeightHelper.isShowingKeyboard ? -100 : -150)
                .padding(.horizontal,10)
                .offset(y: -self.keyboardHeightHelper.cardOffset)
                .scaleEffect(quizCardScale())
            
            Spacer().frame(maxHeight:UIDevice.current.orientation.isPortrait ? 160 : 100)
                
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
                        .padding(.bottom,20)
                    if idiom == .pad {
                        HStack {
                            VStack {
                                Text("Please choose a language code")
                                Picker("Please choose a language code", selection:$sampleCard.languageCode) {
                                    ForEach(languages(), id:\.self) {
                                        Text($0)
                                    }
                                }
                            }
                            VStack {
                                Text("Please choose a group")
                                Picker("Please choose a group", selection:$sampleCard.group) {
                                    ForEach(groups.map{($0.groupname ?? "")}, id:\.self) {
                                        Text($0)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        Text("Please choose a language code")
                        Picker("Please choose a language code", selection:$sampleCard.languageCode) {
                            ForEach(languages(), id:\.self) {
                                Text($0)
                            }
                        }
                        
                        Text("Please choose a group")
                        Picker("Please choose a group", selection:$sampleCard.group) {
                            ForEach(groups.map{($0.groupname ?? "")}, id:\.self) {
                                Text($0)
                            }
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
    
    func quizCardScale() -> CGFloat {
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation

        if orientation!.isPortrait {
            if self.keyboardHeightHelper.isShowingKeyboard {
                return 0.8
            } else {
                return 1.0
            }
            
        } else {
            if self.keyboardHeightHelper.isShowingKeyboard {
                return 0.6
            } else {
                return 0.8
            }
        }
    }
    
    func languages() -> [String] {
        var lang = [String]()
        if !Locale.preferredLanguages.contains("en-GB") {
            lang.append("en-GB")
        }
        if !Locale.preferredLanguages.contains("de") {
            lang.append("de")
        }
        if !Locale.preferredLanguages.contains("zh-Hans-CN") {
            lang.append("zh-Hans-CN")
        }
        lang += Locale.preferredLanguages
        return lang
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
