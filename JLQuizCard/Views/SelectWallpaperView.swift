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
    @State var wallpaperSamples = ["Cat","step2","step3","step4"]
    var body: some View {
        NavigationLink(destination: WallpaperGuideView(),
                       isActive: $wallpaperGuideActive){
            EmptyView()
        }
        VStack {
            Button(action: {
                wallpaperGuideActive = true
            }, label: {
                Text("add shortcut for auto-updating lock screen wallpaper")
                    .foregroundColor(.white)
                    .muyaoFont(size: 26)
                    .padding(.horizontal, 10)
                
            }).frame(width: screenSize.width - 40, height:100)
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
                        Image(sample)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .padding(.horizontal, 20)
            
        }.background(background)
        
    }
    
    var background:some View {
        ZStack{
            Color("Bg1")
            BackgroundView().opacity(0.9)
        }.ignoresSafeArea()
    }
}

struct SelectWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        SelectWallpaperView()
    }
}
