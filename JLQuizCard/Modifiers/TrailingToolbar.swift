//
//  TrailingToolbar.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2022/9/14.
//  Copyright © 2022 jack. All rights reserved.
//

import Foundation
import SwiftUI

struct TrailingToolbar: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
        } else {
            HStack {
                Spacer()
                content
            }
        }
    }
}

extension View {
    func traillingToolbar() -> some View {
        self.modifier(TrailingToolbar())
    }
}
