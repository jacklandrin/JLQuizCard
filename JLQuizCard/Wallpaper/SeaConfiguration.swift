//
//  SeaConfiguration.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/19.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

class SeaConfiguration:WallpaperStyleConfiguration {
    var name: WallpaperStyle = .sea
    
    var backgroundColors: [CGColor] = [UIColor(named: "bBg1")!.cgColor,
                                       UIColor(named: "bBg2")!.cgColor,
                                       UIColor(named: "bBg3")!.cgColor]
    
    var stripeColor: CGColor = UIColor(named: "bstripe")!.cgColor
    
    var textBackgroundColor: CGColor = UIColor(named: "bBg2")!.cgColor
    
    var topImage: CGImage? = nil
    
    var bottomImage: CGImage? = nil
    
    var mainTextColor: UIColor = UIColor(named: "bmaint")!
    
    var secondaryTextColor: UIColor = UIColor(named: "bsect")!
    
    
}
