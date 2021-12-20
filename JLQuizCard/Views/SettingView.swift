//
//  SettingView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/17.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.screenSize) private var screenSize
    @EnvironmentObject var cardPileModel:CardPileViewModel
    @ObservedObject var settingVM = SettingVM()
    
    
    var body: some View {
        NavigationLink(destination: CardList()
                        .environmentObject(cardPileModel)
                        .ignoresSafeArea(),
                       isActive: $settingVM.importActive){
            EmptyView()
        }
        NavigationLink(destination: SelectWallpaperView().ignoresSafeArea(),
                       isActive: $settingVM.wallpaperActive){
            EmptyView()
        }
        
        
        ScrollView{
            VStack(spacing:22) {
                Button(action: {
                    settingVM.wallpaperActive = true
                }, label: {
                    ZStack {
                        Image(decorative:"button_stroke")
                            .resizable()
                            .frame(height:200)
                            .foregroundColor(.white)
                        HStack(spacing:0) {
                            Image("wallpaper_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width:150, alignment:.leading)
                                .shadow(radius: 3)
                            
                            Text("Lock Screen Wallpaper")
                                .muyaoFont(size: 30)
                                .foregroundColor(Color(UIColor.darkGray))
                                .frame(alignment:.leading)
                                .padding(.trailing, 10)
                        }
                    }
                    
                }).frame(maxWidth:350, idealHeight: 200)
                    .background(Color("qzred"))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
                
                Button(action: {
                    settingVM.importActive = true
                }, label: {
                    ZStack {
                        Image(decorative:"button_stroke")
                            .resizable()
                            .frame(height:200)
                            .foregroundColor(.white)
                        HStack(spacing:0) {
                            Image("managecard_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width:150, alignment:.leading)
                                .shadow(radius: 3)
                            Text("Manage Cards")
                                .muyaoFont(size: 30)
                                .foregroundColor(Color(UIColor.darkGray))
                                .frame(alignment:.leading)
                                .padding(.trailing, 10)
                        }
                    }
                }).frame(maxWidth:350, idealHeight: 200)
                    .background(Color("qzblue"))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(UIColor.darkGray).opacity(0.9), style: StrokeStyle(lineWidth: 4, dash: [10])))
            }.padding(.top, 5)
        }.padding(.top, 15)
        .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Setting")
            .background(background)
    }
    
    var background:some View {
        ZStack{
            Color("Bg2")
            BackgroundView().opacity(0.9)
        }.ignoresSafeArea()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
