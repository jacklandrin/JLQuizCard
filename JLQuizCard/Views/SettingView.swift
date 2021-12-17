//
//  SettingView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/17.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var cardPileModel:CardPileViewModel
    @ObservedObject var settingVM = SettingVM()
    var body: some View {
        NavigationLink(destination: CardList().environmentObject(cardPileModel), isActive: $settingVM.importActive){
            Text("")
        }
        NavigationLink(destination: WallpaperGuideView(), isActive: $settingVM.wallpaperActive){
            Text("")
        }

        List{
            Button("Manage Cards") {
                settingVM.importActive = true
            }
            
            Button("Wallpaper Setting") {
                settingVM.wallpaperActive = true
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Setting")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
