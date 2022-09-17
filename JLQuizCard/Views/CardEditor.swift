//
//  CardEditor.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/6.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct CardEditor: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var isPortrait : Bool { UIDevice.current.orientation.isPortrait }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.screenSize) private var screenSize
   
    var finishEditCard : (Card) -> Void
    
    init(isNewOne: Bool, card: CardInfo?, finishEditCard:@escaping (Card) -> Void) {
        
        self.finishEditCard = finishEditCard
        self.viewModel = CardEditorViewModel(isNewOne: isNewOne, card: card)
    }
    
    func onAppearUpdateData() {
        self.viewModel.setupGroups()
        guard self.viewModel.isNewOne || (self.viewModel.card != nil) else {
            return
        }
        
        if !viewModel.isNewOne {
            self.viewModel.sampleCard.isTextMode = (self.viewModel.card?.type == CardType.showText.rawValue)
            self.viewModel.sampleCard.question = self.viewModel.card?.question ?? ""
            self.viewModel.sampleCard.type = CardType(rawValue: self.viewModel.card?.type ?? "showText") ?? .showText
            self.viewModel.sampleCard.answer = self.viewModel.card?.answer ?? ""
            self.viewModel.sampleCard.example = self.viewModel.card?.example ?? ""
            self.viewModel.sampleCard.languageCode = self.viewModel.card?.languageCode ?? "en-GB"
            self.viewModel.sampleCard.group = self.viewModel.card?.ofGroup?.groupname ?? ""
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
                        .environmentObject(viewModel.sampleCard)
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
            if viewModel.isMakingNewCard {
                let card = viewModel.sampleCard
                self.finishEditCard(card)
            }
            
        })
        .alert(isPresented: self.$viewModel.isShowAlert) {
                Alert(title: Text("Warning"), message: Text("Write something"), dismissButton: .default(Text("Got it!")))
        }
        
    }
    
    var inputView:some View {
        ScrollView {
            VStack(alignment:.leading) {
                Toggle(isOn: self.$viewModel.sampleCard.isTextMode.animation()) {
                    Text("Text Mode")
                        .foregroundColor(.black)
                }
                Group{
                    Text("Question:")
                        .foregroundColor(.black)
                    TextField("", text: self.$viewModel.sampleCard.question)
                        .foregroundColor(.black)
                        .frame(height:44)
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                    Text("Example:")
                        .foregroundColor(.black)
                    TextField("", text: self.$viewModel.sampleCard.example)
                        .foregroundColor(.black)
                        .frame(height:44)
                        .padding(.horizontal, 10)
                        .overlay(RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                    Text("Answer:")
                        .foregroundColor(.black)
                    TextField("", text: self.$viewModel.sampleCard.answer)
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
                            
                            Picker("Please choose a language code", selection:$viewModel.sampleCard.languageCode) {
                                ForEach(languages(), id:\.self) {
                                    Text($0)
                                        .foregroundColor(.black)
                                }
                            }.foregroundColor(.black)
                        }
                        
                        HStack {
                            Text("Please choose a group")
                                .foregroundColor(.black)
                            
                            Picker("Please choose a group", selection:$viewModel.sampleCard.group) {
                                ForEach(viewModel.groups.map{($0.groupname ?? "")}, id:\.self) {
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
                        Picker(viewModel.sampleCard.languageCode.isEmpty ? languages().first! : viewModel.sampleCard.languageCode, selection:$viewModel.sampleCard.languageCode) {
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
                        if !self.viewModel.sampleCard.group.isEmpty {
                            Picker(viewModel.sampleCard.group, selection:$viewModel.sampleCard.group) {
                                ForEach(viewModel.groups.map{($0.groupname ?? "")}, id:\.self) {
                                    Text($0)
                                        .foregroundColor(.black)
                                }
                            }.pickerStyle(.menu)
                        }
                        
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
        guard self.viewModel.sampleCard.question != "" else {
            self.viewModel.isShowAlert = true
            return
        }
        
        guard self.viewModel.sampleCard.example != "" else {
            self.viewModel.isShowAlert = true
            return
        }
        
        guard self.viewModel.sampleCard.answer != "" else {
            self.viewModel.isShowAlert = true
            return
        }

        self.presentationMode.wrappedValue.dismiss()
        self.viewModel.isMakingNewCard = true
        
    }
}

struct CardEditor_Previews: PreviewProvider {
    static var previews: some View {
        CardEditor(isNewOne: true, card: nil, finishEditCard: {_ in})
    }
}
