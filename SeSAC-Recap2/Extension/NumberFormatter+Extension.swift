//
//  NumberFormatter+Extension.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/1/24.
//

import Foundation

extension NumberFormatter {
	static func setPrice(_ value: Double, kind: priceKind) -> (value: String, state: PriceState?) {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal

		// formattedValue를 guard형식으로 처리해버릴까 하다가.. maximun을 설정해줘야해서 이렇게도 저렇게도 안되는군요..
//		switch kind {
//		case .price:
//			formatter.maximumFractionDigits = 0
//		case .priceChanging:
//			formatter.maximumFractionDigits =
//		}

		switch kind {
		case .price:

			if value == Double(Int(value)) {
//				return (value.formatted(.currency(code: "krw")), getState(value))
				formatter.maximumFractionDigits = 0
				if let formattedValue = formatter.string(for: value) {
					return ("₩" + formattedValue, getState(value))
				}

			}
			return ("₩\(value)", getState(value))

		case .priceChanging:
			formatter.maximumFractionDigits = 2
			if let formattedValue = formatter.string(for: value) {
				let sign: String
				let state = getState(value)
				switch state {
				case .plus:
					sign = "+"
				default:
					sign = ""
				}
				return (sign + formattedValue + "%", state)
			}
			return (formatter.string(for: value) ?? "-", getState(value))
		}

		func getState(_ value: Double) -> PriceState {
			if value > 0 {
				return .plus
			} else if value == 0 {
				return .zero
			} else {
				return .minus
			}
		}

//		func countDecimalPlaces(number: Double) -> Int {
//			 let numberAsString = String(number)
//			 if let dotIndex = numberAsString.firstIndex(of: ".") {
//				  return numberAsString.distance(from: dotIndex, to: numberAsString.endIndex) - 1
//			 } else {
//				  return 0
//			 }
//		}
	}
}
