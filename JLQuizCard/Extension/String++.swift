//
//  String++.swift
//  JLQuizCard
//
//  Created by Jacklandrin on 2021/12/16.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

extension String{

    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    
    func countOf(subString:String) -> Int {
        return self.components(separatedBy: subString).count
    }
}
