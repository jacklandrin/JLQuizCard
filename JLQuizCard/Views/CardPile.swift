//
//  CardPile.swift
//  JLQuizCard
//
//  Created by jack on 2020/4/5.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct CardPile: View {
//    @EnvironmentObject var cardPileViewModel: CardsPileViewModel
    @State var currentIndex = 0
    @State var isAnimation:Bool = false
    @State var isShowSetting = false
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.screenSize) private var screenSize
    
    @FetchRequest(fetchRequest: CardInfo.defaultFetchRequest)
    var cards:FetchedResults<CardInfo>
    @FetchRequest(fetchRequest: CardGroup.defaultFetchRequest)
    var groups:FetchedResults<CardGroup>
    
    
    @State var cardPile:[Card] = [Card]()
    @State var showGroupSheet = false
    @State var cardPileModel = CardPileViewModel()
    @State var animateGradient = false
    
    @State var currentScreenSize:CGSize = UIScreen.main.bounds.size
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.largeTitleTextAttributes = [.font : UIFont(name: "Muyao-Softbrush",
                                                                     size: 60)!,
                                                      .foregroundColor:UIColor(named:"qzcyan")!]
        coloredAppearance.titleTextAttributes = [.font : UIFont(name: "Muyao-Softbrush",
                                                                size: 24)!,
                                                 .foregroundColor:UIColor(named:"qzcyan")!]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                animationBackground
                BackgroundView()
                VStack {
                    NavigationLink(destination: SettingView().environmentObject(cardPileModel), isActive: $isShowSetting){
                        EmptyView()
                    }
                    //add data after popping animation, unless list page will update View in animation, then go back this view in iOS 14
                    Spacer().frame(height:134 + safeAreaInsets.top)
                    groupButton
                    
                    piles
                        .offset(y:idiom == .pad && currentScreenSize.height > 800 ? currentScreenSize.height * 0.1 : 0)
                    
                    Spacer()
                    buttons
                    Spacer().frame(height:120)
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            .onAppear(){
                convertToShowCards()
                shareSafeArea()
                print("card pile onAppear fired")
            }
            .navigationTitle(Text("QuizCard"))
            .toolbar{
                ToolbarItem(placement:.navigationBarTrailing) {
                   
                    Button(action: {
                        isShowSetting = true
                    }, label: {
                        Image("setting")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    }).traillingToolbar()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
        .environment(\.screenSize, currentScreenSize)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                currentScreenSize = UIScreen.main.bounds.size
            }
        }
        
    }

    var animationBackground:some View {
        LinearGradient(gradient: Gradient(colors: [Color("Bg1"),
                                                   Color("Bg2"),
                                                   Color("Bg3")]),
                                    startPoint: animateGradient ? .topLeading : .bottomLeading,
                                    endPoint: animateGradient ? .bottomTrailing : .topTrailing)
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 10.0).repeatForever(autoreverses: true), value: animateGradient)
            .onAppear {
                    animateGradient.toggle()
            }
    }
    
    var groupButton: some View {
        Button(action:{
            showGroupSheet = true
        }){
            ZStack {
                Image(decorative:"button_stroke")
                    .resizable()
                    .frame(height:50)
                    .foregroundColor(.white)
                Text(selectingGroupButtonName())
                    .muyaoFont(size: 24)
                    .foregroundColor(Color.white)
            }
        }.frame(maxWidth:150, minHeight: 44)
        .background(Color("qzblue"))
        .overlay(RoundedRectangle(cornerRadius: 22)
                    .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .sheet(isPresented: $showGroupSheet, content: {
            SelectGroupView(done: {
                showGroupSheet = false
                print("currenGroup:\(String(describing: groups[cardPileModel.currentGroupIndex].groupname))")
                convertToShowCards()
                currentIndex = 0
            })
                .environmentObject(cardPileModel)
                .ignoresSafeArea()
//         Image(uiImage: WallpaperGenerator.shared.generate()!)
        })
    }
    
    var piles:some View {
        ZStack {
            ForEach((0..<self.cardPile.count).reversed()) { index in
                QuizCard(onDragOut:{ d in
                    if (d < 0 && self.currentIndex == 0) || (d > 0 && Int(self.currentIndex) == self.cardPile.count - 1) || self.isAnimation || d == 0 {
                        return
                    }
                    
                    if d < 0 {
                        withAnimation {
                            self.currentIndex += -1
                            self.isAnimation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                            self.isAnimation = false
                        }
                    } else {
                        self.currentIndex += 1
                        print("current index\(self.currentIndex)")
                    }
                }, sequence: Int(index + 1))
                .environmentObject(cardPile[index])
                .cardTransformed(Double(self.currentIndex), card: index)
            }
                    
        }.padding(.bottom,80)
        .padding(.top, safeAreaInsets.bottom > 0 ? 20 : 0)
        .padding(.horizontal, 24)
        .offset(y: safeAreaInsets.bottom == 0 ? -40 : 0)
    }
    
    var buttons:some View {
        HStack{
            Button(action:{
                groups[cardPileModel.currentGroupIndex].cardArray[currentIndex].weight += 2
                flipNextCard()
            }) {
                Text("Hard")
                    .muyaoFont(size: 24)
                    .foregroundColor(Color.white)
            }.remenberButtonStyle(color: Color("qzred"))
            
            Button(action:{
                groups[cardPileModel.currentGroupIndex].cardArray[currentIndex].weight += 1
                flipNextCard()
            }) {
                Text("Good")
                    .muyaoFont(size: 24)
                    .foregroundColor(Color.white)
            }
            .remenberButtonStyle(color: Color("qzgreen"))
            
            Button(action:{
                groups[cardPileModel.currentGroupIndex].cardArray[currentIndex].weight -= 1
                flipNextCard()
            }) {
                Text("Easy")
                    .muyaoFont(size: 24)
                    .foregroundColor(Color.white)
            }
            .remenberButtonStyle(color: Color.gray)
            
        }.padding(.horizontal, 20)
    }
    
    func convertToShowCards() {
        self.cardPile = [Card]()
        guard groups.count > 0 else {
            return
        }
        for item in groups[cardPileModel.currentGroupIndex].cardArray {
            let card = Card.convertCard(cardInfo: item)
            self.cardPile.append(card)
        }
    }
    
    func selectingGroupButtonName() -> String {
        guard groups.count > 0 else {
            return "Group"
        }
        let groupName = cardPileModel.groupNames[cardPileModel.currentGroupIndex]
        if groupName == "" {
            return "Group"
        } else {
            return groupName
        }
    }
    
    func flipNextCard() {
        if self.currentIndex != self.cardPile.count - 1 {
            withAnimation {
                self.currentIndex += 1
                self.isAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                self.isAnimation = false
            }
            saveContext()
        }
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func shareSafeArea() {
        let safeAreaBottom = safeAreaInsets.bottom
        let userDefalts = UserDefaults(suiteName: appGroup)
        userDefalts?.set(safeAreaBottom, forKey: safeAreaBottomKey)
        userDefalts?.synchronize()
    }
}

//struct CardPile_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPile().environmentObject(CardsPileViewModel())
//    }
//}
