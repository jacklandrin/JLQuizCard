//
//  SelectWallpaperView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/18.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct SelectWallpaperView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.screenSize) private var screenSize
    @State var wallpaperGuideActive = false
    @State var wallpaperSamples:[WallpaperStyle] = [.spring,.firstlove,.sea,.autumn]
    @State var currentStyle:WallpaperStyle = WallpaperGenerator.shared.currentStyle

    var body: some View {
        NavigationLink(destination: WallpaperGuideView(),
                       isActive: $wallpaperGuideActive){
            EmptyView()
        }
        VStack {
            if #available(iOS 15, *) {
                Spacer().frame(height: 0)
            } else {
                Spacer().frame(height: 64 + safeAreaInsets.top)
            }
            Button(action: {
                wallpaperGuideActive = true
            }, label: {
                Text("add shortcut for auto-updating lock screen wallpaper")
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                
            }).frame(width: screenSize.width - 40, height:80)
                .background(Color("qzblue"))
                .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(UIColor.darkGray).opacity(0.9),
                                    style: StrokeStyle(lineWidth: 4, dash: [10])))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal,10)
                .shadow(color: Color("qzblue").opacity(0.3), radius: 4, x: 4, y: 4)
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(wallpaperSamples, id:\.self) { sample in
                        Image(sample.sampleImageName())
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 5)
                            .selected(sample == currentStyle)
                            .cornerRadius(20)
                            .onTapGesture {
                                currentStyle = sample
                                let userDefalts = UserDefaults(suiteName: appGroup)!
                                userDefalts.set(sample.rawValue, forKey: WallpaperStyleKey)
                                userDefalts.synchronize()
                            }
                    }
                }.padding(.horizontal, 4)
                Spacer(minLength: safeAreaInsets.bottom + 10)
            }
            .padding(.horizontal, 20)
            
        }.background(background)
            .navigationTitle("Wallpaper")
    }
    
    var background:some View {
        ZStack{
            Color("Bg1")
            BackgroundView().opacity(0.2)
        }.ignoresSafeArea()
    }
}

struct SelectWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        SelectWallpaperView()
    }
}
