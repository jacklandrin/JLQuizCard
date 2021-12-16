//
//  CGPoint+Extensions.swift
//  TextDrawing
//
//  Created by Dominik Olędzki on 02/02/2017.
//  Copyright © 2017 Dominik Oledzki. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static var nan: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan)
    
    var isNaN: Bool {
        return x.isNaN && y.isNaN
    }
    
    var isFinite: Bool {
        return x.isFinite && y.isFinite
    }
}
