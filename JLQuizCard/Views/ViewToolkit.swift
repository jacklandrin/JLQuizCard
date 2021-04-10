//
//  ViewToolkit.swift
//  JLQuizCard
//
//  Created by jack on 2021/3/16.
//  Copyright © 2021 jack. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: about device rotation
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

// MARK: - a navigationbar with title and a trailing link, compatible with iOS 14 & 13
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

// MARK: - a navigationbar with title and a trailing button, compatible with iOS 14 & 13
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

// MARK: - a inline navigationbar with title and a trailing link, compatible with iOS 14 & 13
@available(iOS 14,*)
struct NavigationTitleInlineAndToolbarButton:ViewModifier {
    let title : String
    let action : () -> Void
    let trailingText : String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{ ToolbarItem(placement:.navigationBarTrailing) {
                        Button(action:action){
                            Text(trailingText)
                        }
                }
            }
    }
}

struct NavigationTitleInlineAndTrailingButton:ViewModifier {
    let title : String
    let action : () -> Void
    let trailingText : String
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:action){
                Text(trailingText)
            })
    }
}

extension View {
    @ViewBuilder
    func changeNavigationTitleInlineAndTrailingButton(title:String, trailingText:String, action: @escaping () -> Void) -> some View {
        if #available(iOS 14, *) {
            self.modifier(NavigationTitleInlineAndToolbarButton(title: title, action: action, trailingText: trailingText))
        } else {
            self.modifier(NavigationTitleInlineAndTrailingButton(title: title, action: action, trailingText: trailingText))
        }
    }
}

// MARK: - plain style list
struct ListWithPlainStyle:ViewModifier {
    func body(content: Content) -> some View {
        content.listStyle(PlainListStyle())
    }
}

@available(iOS 14,*)
struct ListWithSidebarStyle:ViewModifier {
    func body(content: Content) -> some View {
        content.listStyle(SidebarListStyle())
    }
}

extension List {
    @ViewBuilder
    func defaultListStyle() -> some View {
        if #available(iOS 14, *) {
            self.modifier(ListWithSidebarStyle())
        } else {
            self.modifier(ListWithPlainStyle())
        }
    }
}

// MARK: - for keyboard botton ignored area
@available(iOS 14, *)
struct keyboardBottonIgnore:ViewModifier {
    func body(content: Content) -> some View {
        content.ignoresSafeArea(.keyboard,edges: .bottom)
    }
}

struct keyboardBottonLift:ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    @ViewBuilder
    func ignoreKeyboardArea() -> some View {
        if #available(iOS 14, *) {
            self.modifier(keyboardBottonIgnore())
        } else {
            self.modifier(keyboardBottonLift())
        }
    }
}

// MARK: - for CardPile view's buttons
struct ButtonStyle : ViewModifier{
    let color : Color
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 120, minHeight:50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal,20)
    }
}

extension Button {
    @ViewBuilder
    func remenberButtonStyle(color:Color) -> some View {
        self.modifier(ButtonStyle(color: color))
    }
}

// MARK: - observe changes in orientation
final class OrientationInfo: ObservableObject {
    enum Orientation {
        case portrait
        case landscape
    }
    
    @Published var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
    
    init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        }
        else {
            self.orientation = .portrait
        }
        
        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                self.orientation = .portrait
            }
            else if device.orientation.isLandscape {
                self.orientation = .landscape
            }
        }
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// MARK: - hidden with a boolean parameter.
extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        } else {
            self
        }
    }
}
