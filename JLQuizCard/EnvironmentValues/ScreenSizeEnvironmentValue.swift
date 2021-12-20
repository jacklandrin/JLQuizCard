//
//  ScreenSizeEnvironmentValue.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/18.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import SwiftUI

private struct ScreenSizeKey:EnvironmentKey {
    static var defaultValue: CGSize {
        UIScreen.main.bounds.size
    }
}

extension EnvironmentValues {
    var screenSize:CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue}
    }
}

