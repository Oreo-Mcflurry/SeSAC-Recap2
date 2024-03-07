//
//  CoinInfoUIView.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit
import SnapKit

class CoinInfoUIView: BaseUIView {
	let imageView = UIImageView()
	let coinNameLabel = UILabel()
	let symbolLabel = UILabel()

	override func configureHierarchy() {
		[imageView, coinNameLabel, symbolLabel].forEach { addSubview($0) }
	}

	override func configureLayout() {
		imageView.snp.makeConstraints {
			$0.leading.equalTo(self)
			$0.verticalEdges.equalTo(self)
			$0.size.equalTo(40)
		}

		coinNameLabel.snp.makeConstraints {
			$0.leading.equalTo(imageView.snp.trailing).offset(10)
			$0.top.equalTo(imageView.snp.top)
			$0.trailing.equalTo(self).inset(10)
		}

		symbolLabel.snp.makeConstraints {
			$0.top.greaterThanOrEqualTo(coinNameLabel.snp.bottom)
			$0.leading.equalTo(imageView.snp.trailing).offset(10)
			$0.bottom.equalTo(imageView.snp.bottom)
			$0.trailing.equalTo(self)
		}
	}

	override func configureView() {
		backgroundColor = .clear
		coinNameLabel.font = .boldSystemFont(ofSize: 18)
		symbolLabel.textColor = .gray
	}
}

