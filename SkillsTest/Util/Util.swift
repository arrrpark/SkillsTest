//
//  Util.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit

struct Util {
    static let shared = Util()
    
    private init () { }
    
    static let guidelineBaseWidth = 375.0
    static let guidelineBaseHeight = 667.0
}

@inline(__always)
func horizontalScale(_ number: CGFloat) -> CGFloat {
    (UIScreen.main.bounds.width / Util.guidelineBaseWidth) * number
}

@inline(__always)
func verticalScale(_ number: CGFloat) -> CGFloat {
    (UIScreen.main.bounds.height / Util.guidelineBaseHeight) * number
}

@inline(__always)
func moderateScale(_ number: CGFloat, factor: CGFloat = 0.5) -> CGFloat {
    number + (horizontalScale(number) - number) * factor
}

@inline(__always)
func getSafeAreaTopBottom() -> (top: CGFloat, bottom: CGFloat) {
    let window = UIApplication.shared.windows[0]
    let safeFrame = window.safeAreaLayoutGuide.layoutFrame
    return (safeFrame.minY, window.frame.maxY - safeFrame.maxY)
}

@inline(__always)
func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor {
    var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cleanString.hasPrefix("#")) {
        cleanString.remove(at: cleanString.startIndex)
    }

    if ((cleanString.count) != 6) {
        return .white
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cleanString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
