//
//  UILabel+Extension.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import Foundation
import UIKit

extension UILabel {
    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
    }
    
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: style,
                range: NSRange(location: 0, length: attributedStr.length))
            self.attributedText = attributedStr
        }
    }
}
