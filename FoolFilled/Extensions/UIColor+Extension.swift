//
//  UIColor+Extension.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit

extension UIColor {
    func rgba() -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)? {
        var floatRed: CGFloat = 0
        var floatGreen: CGFloat = 0
        var floatBlue: CGFloat = 0
        var floatAlpha: CGFloat = 0

        let success = self.getRed(&floatRed, green: &floatGreen, blue: &floatBlue, alpha: &floatAlpha)
        if success {
            let red = UInt8(floatRed * 255)
            let green = UInt8(floatGreen * 255)
            let blue = UInt8(floatBlue * 255)
            let alpha = UInt8(floatAlpha * 255)
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }
}
