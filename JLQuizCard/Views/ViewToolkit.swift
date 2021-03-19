//
//  ViewToolkit.swift
//  JLQuizCard
//
//  Created by jack on 2021/3/16.
//  Copyright © 2021 jack. All rights reserved.
//

import UIKit
import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
@available(iOS 14.0, *)
struct NavigationTitleAndToolbarLink<Destination> : ViewModifier where Destination:View {
    let title: String
    let destination:Destination
    let trailingText: String
    @State var isActive = false
    
    func body(content: Content) -> some View {

            return content
                    .navigationTitle(title)
                .toolbar{ ToolbarItem(placement:.navigationBarTrailing) {
                        NavigationLink(destination:
                                        destination, isActive:$isActive ,label:{
                                            Text(trailingText)
                                        })

                    }
                }
            
    }
}

struct NavigationTitleAndTrailingLink<Destination> :ViewModifier where Destination:View {
    let title: String
    let destination:Destination
    let trailingText: String
    
    func body(content: Content) -> some View {
    
            return content
                .navigationBarTitle(title)
                .navigationBarItems(trailing: NavigationLink(destination:
                                                                destination, label:{
                                                                    Text(trailingText)
                                                                                    }
                                                            )
                )
        

    }
        
}

extension View {
    @ViewBuilder
    func changeNavigationTitleAndTrailingLink<Destination>(title: String, destination:Destination, trailingText:String) -> some View where Destination:View {
        if #available(iOS 14.0, *) {
            self.modifier(NavigationTitleAndToolbarLink<Destination>(title: title, destination: destination, trailingText: trailingText))
        } else {
            self.modifier(NavigationTitleAndTrailingLink<Destination>(title: title, destination: destination, trailingText: trailingText))
        }
       
    }
}

@available(iOS 14,*)
struct NavigationTitleAndToolbarButton:ViewModifier {
    let title : String
    let action : () -> Void
    let trailingText : String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .toolbar{ ToolbarItem(placement:.navigationBarTrailing) {
                        Button(action:action){
                            Text(trailingText)
                        }
                }
            }
    }
}

struct NavigationTitleAndTrailingButton:ViewModifier {
    let title : String
    let action : () -> Void
    let trailingText : String
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(title)
            .navigationBarItems(trailing: Button(action:action){
                Text(trailingText)
            })
    }
}

extension View {
    @ViewBuilder
    func changeNavigationTitleAndTrailingButton(title:String, trailingText:String, action: @escaping () -> Void) -> some View {
        if #available(iOS 14, *) {
            self.modifier(NavigationTitleAndToolbarButton(title: title, action: action, trailingText: trailingText))
        } else {
            self.modifier(NavigationTitleAndTrailingButton(title: title, action: action, trailingText: trailingText))
        }
    }
}
