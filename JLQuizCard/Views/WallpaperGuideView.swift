//
//  WallpaperGuideView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/17.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct WallpaperGuideView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.screenSize) private var screenSize
    @State var tabIndex = 0
    @State var animationScale = false
    init() {
        UITabBar.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 34)
            Text("Set lock screen Quiz Card")
                .foregroundColor(Color(UIColor.darkGray))
                .muyaoFont(size: 26)
                .frame(alignment:.leading)
            
            TabView(selection: $tabIndex) {
                addShortcutsPage.tag(0)
                step2.tag(1)
                step3.tag(2)
                step4.tag(3)
                step5.tag(4)
                step6.tag(5)
                step7.tag(6)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .background(Color("Bg2")
                            .opacity(0.7)
                            .cornerRadius(24)
                            .padding(.horizontal, 20)
                            )
            
            Spacer().frame(height: 40)
            
        }.background(background)
    }
    
    var background:some View {
        ZStack{
            Color("Bg1")
            BackgroundView().opacity(0.9)
        }.ignoresSafeArea()
    }
    
    var addShortcutsPage:some View {
        VStack(spacing:20) {
            Spacer().frame(height:30)
            HStack {
                Text("Step 1:")
                    .foregroundColor(Color(UIColor.darkGray))
                    .muyaoFont(size: 24)
                    .padding(.leading, 24)
                Spacer()
            }
           
            Image("shortcuts_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text("Creat Quiz Card Command")
                .foregroundColor(Color(UIColor.darkGray))
                .fontWeight(.bold)
                .muyaoFont(size: 30)
            
            Text("tap \"+\" to creat")
                .foregroundColor(Color(UIColor.darkGray))
                .muyaoFont(size: 24)
            
            Link(destination: URL(string: "https://www.icloud.com/shortcuts/d6ca783352844b70a36e4139b40680b4")!) {
                ZStack {
                    Group{
                        Circle()
                            .foregroundColor(Color("qzred").opacity(0.7))
                            .frame(width: 90, height: 90)
                        Circle()
                            .foregroundColor(Color("qzred"))
                            .frame(width: 80, height: 80)
                    }.scaleEffect(animationScale ? 1.2 : 0.9)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animationScale)
                        .onAppear{
                            animationScale.toggle()
                        }
                    
                    Image(systemName: "plus")
                        .foregroundColor(Color(UIColor.darkGray))
                        .font(.system(size: 40))
                }
            }.padding(.top, 20)
            
            Spacer()
        }
    }
    
    var step2:some View {
        StepView(title: "Step 2:",
                 description: "Go to Shortcuts App, and select Automation tab, then select \"Create Personal Automation\"",
                 imageName: "step2")
    }
    
    var step3: some View {
        StepView(title: "Step 3:",
                 description: "Select \"Time of Day\"",
                 imageName: "step3")
    }
    
    var step4: some View {
        StepView(title: "Step 4:",
                 description: "Set a time when the wallpaper updates",
                 imageName: "step4")
    }
    
    var step5: some View {
        StepView(title: "Step 5:", description: "Search \"Run\" and select \"Run Shortcut\"", imageName: "step5")
    }
    
    var step6: some View {
        StepView(title: "Step 6:", description: "Select shortcut \"Set Quiz Card Wallpaper\" and press Next", imageName: "step6")
    }
    
    var step7: some View {
        StepView(title: "Step 7:", description: "untoggle \"Ask Before Running\", then press \"Don't ask\". Finally, press Done", imageName: "step7")
    }
}

struct StepView:View {
    let title:String
    let description:String
    let imageName:String
    
    init(title:String, description:String, imageName: String) {
        self.title = title
        self.description = description
        self.imageName = imageName
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height:30)
            HStack {
                Text(title)
                    .foregroundColor(Color(UIColor.darkGray))
                    .muyaoFont(size: 24)
                    .padding(.leading, 24)
                Spacer()
            }
            Text(description)
                .foregroundColor(Color(UIColor.darkGray))
                .frame(alignment:.leading)
                .padding(.horizontal, 24)
                
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(18)
                .padding(.horizontal,20)
                .padding(.bottom, 44)
        }
    }
}

struct WallpaperGuideView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperGuideView()
    }
}
