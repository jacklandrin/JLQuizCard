//
//  WallpaperGuideView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/17.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct WallpaperGuideView: View {
    var body: some View {
        Link("add shortcut", destination: URL(string: "https://www.icloud.com/shortcuts/d6ca783352844b70a36e4139b40680b4")!)
    }
}

struct WallpaperGuideView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperGuideView()
    }
}
