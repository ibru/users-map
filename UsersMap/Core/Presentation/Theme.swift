//
//  Theme.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import UIKit

struct Theme {
    static var current: Self = .main

    let colorTheme: ColorTheme
    let fontTheme: FontTheme
}

extension Theme {
    static var main: Self {
        .init(colorTheme: .main, fontTheme: .main)
    }
}

extension Theme {
    func style(headlineLabel: UILabel) {
        headlineLabel.textColor = colorTheme.primaryFontColor()
        headlineLabel.font = fontTheme.headlineFont()
    }

    func style(headlineBolderLabel: UILabel) {
        headlineBolderLabel.textColor = colorTheme.primaryFontColor()
        headlineBolderLabel.font = fontTheme.headlineBolderFont()
    }

    func style(captionLabel: UILabel) {
        captionLabel.textColor = colorTheme.secondaryFontColor()
        captionLabel.font = fontTheme.captionFont()
    }
}

struct ColorTheme {
    let primaryFontColor: () -> UIColor
    let secondaryFontColor: () -> UIColor
    let lightGray: () -> UIColor
}

extension ColorTheme {
    static var main: Self {
        .init(
            primaryFontColor: { UIColor(red: 0.165, green: 0.18, blue: 0.263, alpha: 1) },
            secondaryFontColor: { UIColor(red: 0.742, green: 0.742, blue: 0.742, alpha: 1) },
            lightGray: { UIColor(red: 0.964, green: 0.964, blue: 0.964, alpha: 1) }
        )
    }
}

struct FontTheme {
    let navigationTitleFont: () -> UIFont
    let titleFont: () -> UIFont
    let headlineFont: () -> UIFont
    let headlineBolderFont: () -> UIFont
    let captionFont: () -> UIFont
    let footnoteFont: () -> UIFont
}

extension Theme {

}

extension FontTheme {
    static var main: Self {
        .init(
            navigationTitleFont: { UIFont(name: "CircularStd-Black", size: 32)! },
            titleFont: { UIFont(name: "CircularStd-Bold", size: 24)! },
            headlineFont: { UIFont(name: "CircularStd-Book", size: 17)! },
            headlineBolderFont: { UIFont(name: "CircularStd-Medium", size: 17)! },
            captionFont: { UIFont(name: "CircularStd-Book", size: 12)! },
            footnoteFont: { UIFont(name: "CircularStd-Book", size: 12)! }
        )
    }
}
