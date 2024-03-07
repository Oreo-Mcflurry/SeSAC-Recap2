//
//  FavoriteCollectionViewCell.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

import UIKit
import SnapKit

class FavoriteCollectionViewCell: BaseCollectionViewCell {
	let infoView = CoinInfoUIView()
	let priceLabel = UILabel()
	let priceChangingLabel = PaddingLabel()

	override func configureHierarchy() {
		[infoView, priceLabel, priceChangingLabel].forEach { self.contentView.addSubview($0) }
	}

	override func configureLayout() {
		infoView.snp.makeConstraints {
			$0.top.leading.equalTo(self.contentView).inset(10)
			$0.trailing.lessThanOrEqualTo(self.contentView).inset(10)
		}

		priceLabel.snp.makeConstraints {
			$0.top.greaterThanOrEqualTo(infoView.snp.bottom).offset(10)
			$0.leading.greaterThanOrEqualTo(self.contentView).offset(10)
			$0.trailing.equalTo(self.contentView).inset(10)
		}

		priceChangingLabel.snp.makeConstraints {
			$0.top.equalTo(priceLabel.snp.bottom).offset(5)
			$0.bottom.trailing.equalTo(self.contentView).inset(10)
			$0.leading.greaterThanOrEqualTo(self.contentView).inset(10)
		}

//		priceLabel.snp.makeConstraints {
//			$0.top.equalTo(infoView.snp.bottom)
//			$0.bottom.equalTo(priceLabel.snp.top)
//			$0.trailing.equalTo(self.contentView).inset(10)
//			$0.leading.greaterThanOrEqualTo(self.contentView).inset(10)
//			$0.top.lessThanOrEqualTo(infoView.snp.bottom).inset(10)
//		}
	}

	override func configureView() {
		self.backgroundColor = .colorWhite
		layer.borderWidth = 1.0
		layer.borderColor = UIColor.colorLightGray.cgColor
		layer.cornerRadius = 8.0
		layer.shadowColor = UIColor.colorDarkGray.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2)
		layer.shadowOpacity = 0.4
		layer.shadowRadius = 3.0
		priceLabel.font = .boldSystemFont(ofSize: 20)
	}
}
