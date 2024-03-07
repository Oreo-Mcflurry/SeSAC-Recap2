//
//  AttributedString+Extension.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit

extension NSAttributedString {
	static func attributedRed(withFullString fullstr: String, of str: String) -> NSAttributedString {

		let attributedString = NSMutableAttributedString(string: fullstr)
		let range = (fullstr as NSString).range(of: str, options:.caseInsensitive)
//		let underRange = (fullstr as NSString).range(of: str.lowercased())
//		let upperRange = (fullstr as NSString).range(of: str.uppercased())

//		, underRange, upperRange
		[range].forEach { attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: $0) }

		return attributedString
	}
}
