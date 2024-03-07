//
//  PaddingLabel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

import UIKit

class PaddingLabel: UILabel {
	var topInset: CGFloat = 5.0
	var bottomInset: CGFloat = 5.0
	var leftInset: CGFloat = 10.0
	var rightInset: CGFloat = 10.0

	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		super.drawText(in: rect.inset(by: insets))
	}
	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
	}
	override var bounds: CGRect {
		didSet {
			preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
			clipsToBounds = true
			layer.cornerRadius = 10
		}
	}
}
