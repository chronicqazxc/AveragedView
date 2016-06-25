//
//  Extensions.swift
//  AutoLayoutTest
//
//  Created by Wayne Hsiao on 6/25/16.
//  Copyright © 2016 Wayne Hsiao. All rights reserved.
//

import UIKit

internal extension UIColor {
    static func randomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
