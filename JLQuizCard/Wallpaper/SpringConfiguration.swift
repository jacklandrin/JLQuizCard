//
//  SpringConfiguration.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/19.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

class SpringConfiguration:WallpaperStyleConfiguration {
    var name: WallpaperStyle = .spring
    
    var backgroundColors: [CGColor] = [UIColor(named: "Bg1")!.cgColor,
                                       UIColor(named: "Bg2")!.cgColor,
                                       UIColor(named: "Bg3")!.cgColor]
    
    var stripeColor: CGColor = UIColor(named: "stripe")!.cgColor
    
    var textBackgroundColor: CGColor = UIColor(named: "Bg2")!.cgColor
    
    var topImage: CGImage? = nil
    
    var bottomImage: CGImage? = nil
    
    var mainTextColor: UIColor = UIColor(named: "gmaint")!
    var secondaryTextColor: UIColor = UIColor(named: "gsect")!
}
