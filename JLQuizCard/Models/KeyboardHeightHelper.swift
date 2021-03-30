//
//  KeyboardHeightHelper.swift
//  JLQuizCard
//
//  Created by jack on 2021/3/30.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

let animationDuration:Double = 0.5

class KeyboardHeightHelper: ObservableObject {
    @Published var cardOffset: CGFloat = 0
    @Published var keyboardHeight: CGFloat = 0
    @Published var isShowingKeyboard = false
    
    init() {
        self.listenForKeyboardNotification()
    }
    
    private func listenForKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            withAnimation(.linear(duration: animationDuration)) {
                self.isShowingKeyboard = true
                self.keyboardHeight = keyboardRect.height
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if UIDevice.current.orientation.isPortrait {
                        self.cardOffset = 0
                    } else {
                        self.cardOffset = 100
                    }
                } else {
                    self.cardOffset = 60
                }
            }

        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation(.linear(duration: animationDuration)) {
                self.isShowingKeyboard = false
                self.keyboardHeight = 0
                self.cardOffset = 0
            }
            
        }
    }
}
