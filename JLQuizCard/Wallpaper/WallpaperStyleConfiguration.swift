//
//  WallpaperStyleConfiguration.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/19.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

enum WallpaperStyle:String {
    case spring = "Spring"
    case firstlove = "First Love"
    case sea = "Sea"
    case autumn = "autumn"
    
    func sampleImageName() -> String {
        switch self {
        case .spring:
            return "green_stripe_view"
        case .firstlove:
            return "red_stripe_view"
        case .sea:
            return "blue_stripe_view"
        case .autumn:
            return "yellow_stripe_view"
        }
    }
    
    func configuration() -> WallpaperStyleConfiguration {
        switch self {
        case .spring:
            return SpringConfiguration()
        case .firstlove:
            return FirstLoveConfiguration()
        case .sea:
            return SeaConfiguration()
        case .autumn:
            return AutumnConfiguration()
        }
    }
}

protocol WallpaperStyleConfiguration:AnyObject {
    var name:WallpaperStyle {get set}
    var backgroundColors:[CGColor] {get set}
    var stripeColor:CGColor {get set}
    var textBackgroundColor:CGColor {get set}
    var topImage:CGImage? {get set}
    var bottomImage:CGImage? {get set}
    var mainTextColor:UIColor {get set}
    var secondaryTextColor:UIColor {get set}
}
