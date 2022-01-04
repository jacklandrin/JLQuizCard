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
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.screenSize) private var screenSize
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    var isNewOne: Bool
    var card : CardInfo?
    @State var isMakingNewCard = false
    @State var isShowAlert: Bool = false
    @State var languageCode = "en-GB"
    
    @State var sampleCard: Card = Card(question: "",
                                       answer: "",
                                       example: "",
                                       languageCode: "",
                                       type: .showText,
                                       weight: 0)
    
    
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
            Spacer().frame(height: safeAreaInsets.top + 44)
            
            ZStack {
                VStack {
                    inputView
                    Spacer()
                }
               
                VStack {
                    Spacer().frame(height:screenSize.height / 2 - 130)
                    QuizCard(onDragOut: {_ in}, sequence: 1)
                        .environmentObject(sampleCard)
                        .frame(height:200)
                        .padding(.horizontal,10)
                    Spacer().frame(minHeight:0, maxHeight:UIDevice.current.orientation.isPortrait ? 224 : 144)
                }
               
            }.edgesIgnoringSafeArea(.bottom)
            
            Spacer()
        }
        .padding(.horizontal, 10.0)
        .background(Color("Bg3"))
        .navigationTitle("Card Editor")
        .ignoresSafeArea()
        .toolbar{
            ToolbarItem(placement:.navigationBarTrailing) {
                Button(action: {
                    makeNewCard()
                }, label: {
                    Text("Done")
                        .muyaoFont(size: 26)
                })
            }
        }
        .onAppear(perform: onAppearUpdateData)
        .onDisappear(perform: {
            if isMakingNewCard {
                let card = sampleCard
                self.finishEditCard(card)
            }
            
        })
        .alert(isPresented: self.$isShowAlert) {
                Alert(title: Text("Warning"), message: Text("Write something"), dismissButton: .default(Text("Got it!")))
        }
        
    }
    
    var inputView:some View {
        ScrollView {
            VStack(alignment:.leading) {
                Toggle(isOn: self.$sampleCard.isTextMode.animation()) {
                    Text("Text Mode")
                        .foregroundColor(.black)
                }
                Group{
                    Text("Question:")
                        .foregroundColor(.black)
                    TextField("", text: self.$sampleCard.question)
                        .foregroundColor(.black)
                        .frame(height:44)
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                    Text("Example:")
                        .foregroundColor(.black)
                    TextField("", text: self.$sampleCard.example)
                        .foregroundColor(.black)
                        .frame(height:44)
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                    Text("Answer:")
                        .foregroundColor(.black)
                    TextField("", text: self.$sampleCard.answer)
                        .foregroundColor(.black)
                        .frame(height:44)
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                        .padding(.bottom,20)
                        
                }
                
                if idiom == .pad {
                    HStack(spacing:20) {
                        HStack {
                            Text("Please choose a language code")
                                .foregroundColor(.black)
                            
                            Picker("Please choose a language code", selection:$sampleCard.languageCode) {
                                ForEach(languages(), id:\.self) {
                                    Text($0)
                                        .foregroundColor(.black)
                                }
                            }.foregroundColor(.black)
                        }
                        
                        HStack {
                            Text("Please choose a group")
                                .foregroundColor(.black)
                            
                            Picker("Please choose a group", selection:$sampleCard.group) {
                                ForEach(groups.map{($0.groupname ?? "")}, id:\.self) {
                                    Text($0)
                                        .foregroundColor(.black)
                                }
                            }.foregroundColor(.black)
                        }
                        
                    }
                } else {
            
                    HStack {
                        Text("Language code")
                            .foregroundColor(.black)
                        Spacer()
                        Picker(sampleCard.languageCode.isEmpty ? languages().first! : sampleCard.languageCode, selection:$sampleCard.languageCode) {
                            ForEach(languages(), id:\.self) {
                                Text($0)
                                    .foregroundColor(.black)
                            }
                        }.pickerStyle(.menu)
                    }
                    HStack {
                        Text("Group")
                            .foregroundColor(.black)
                        Spacer()
                        Picker(sampleCard.group.isEmpty ? groups.first!.groupname! : sampleCard.group, selection:$sampleCard.group) {
                            ForEach(groups.map{($0.groupname ?? "")}, id:\.self) {
                                Text($0)
                                    .foregroundColor(.black)
                            }
                        }.pickerStyle(.menu)
                    }
                    
                }
                Spacer()
            }.padding(.horizontal, 20)
        }.frame(height:screenSize.height / 2)
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
