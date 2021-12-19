//
//  FirstLoveConfiguration.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/19.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

class FirstLoveConfiguration:WallpaperStyleConfiguration {
    var name: WallpaperStyle = .firstlove
    
    var backgroundColors: [CGColor] = [UIColor(named: "rBg1")!.cgColor,
                                       UIColor(named: "rBg2")!.cgColor,
                                       UIColor(named: "rBg3")!.cgColor]
    
    var stripeColor: CGColor = UIColor(named: "rstripe")!.cgColor
    
    var textBackgroundColor: CGColor = UIColor(named: "rBg2")!.cgColor
    
    var topImage: CGImage? = nil
    
    var bottomImage: CGImage? = nil
    
    var mainTextColor: UIColor = UIColor(named: "rmaint")!
    
    var secondaryTextColor: UIColor = UIColor(named: "rsect")!
    
    
}
