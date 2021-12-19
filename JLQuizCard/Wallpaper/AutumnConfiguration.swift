//
//  AutumnConfiguration.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/19.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

class AutumnConfiguration:WallpaperStyleConfiguration {
    var name: WallpaperStyle = .autumn
    
    var backgroundColors: [CGColor] = [UIColor(named: "yBg1")!.cgColor,
                                       UIColor(named: "yBg2")!.cgColor,
                                       UIColor(named: "yBg3")!.cgColor]
    
    var stripeColor: CGColor = UIColor(named: "ystripe")!.cgColor
    
    var textBackgroundColor: CGColor = UIColor(named: "yBg2")!.cgColor
    
    var topImage: CGImage? = nil
    
    var bottomImage: CGImage? = nil
    
    var mainTextColor: UIColor = UIColor(named: "ymaint")!
    
    var secondaryTextColor: UIColor = UIColor(named: "ysect")!
    
    
}
