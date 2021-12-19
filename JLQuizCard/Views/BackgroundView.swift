//
//  BackgroundView.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/18.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    
    @Environment(\.screenSize) private var screenSize
    var body: some View {
        ZStack{
            Group {
                HStack {
                    ForEach(0..<Int(screenSize.width) / 40) { _ in
                        Rectangle()
                            .foregroundColor(Color("stripe"))
                            .frame(width: 20, height: screenSize.height, alignment: .leading)
                            .padding(.trailing, 20)
                    }
                }.ignoresSafeArea()
                
                VStack {
                    ForEach(0..<Int(screenSize.height) / 40) { _ in
                        Rectangle()
                            .foregroundColor(Color("stripe"))
                            .frame(width: screenSize.width, height: 20, alignment: .top)
                            .padding(.bottom, 20)
                    }
                }.ignoresSafeArea()
            }.opacity(0.75)
        }.frame(width: screenSize.width, height: screenSize.height)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
