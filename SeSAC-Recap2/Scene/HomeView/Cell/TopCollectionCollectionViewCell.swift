//
//  TopCollectionViewCell.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/2/24.
//

import UIKit
import SnapKit

class TopCollectionCollectionViewCell: BaseCollectionViewCell {
	let ratingLabel = UILabel()
	let infoView = CoinInfoUIView()
	let priceLabel = UILabel()
	let priceChangingLabel = UILabel()

	override func configureHierarchy() {
		[ratingLabel, infoView, priceLabel, priceChangingLabel].forEach { self.contentView.addSubview($0) }
	}

	override func configureLayout() {
		ratingLabel.snp.makeConstraints {
			$0.leading.verticalEdges.equalTo(self.contentView).inset(10)
		}

		infoView.snp.makeConstraints {
			$0.leading.equalTo(ratingLabel.snp.trailing).offset(10)
			$0.verticalEdges.equalTo(self.contentView).inset(10)
		}

		priceLabel.snp.makeConstraints {
			$0.top.equalTo(infoView.snp.top)
			$0.trailing.equalTo(self.contentView)
			$0.leading.greaterThanOrEqualTo(infoView.snp.trailing)
		}

		priceChangingLabel.snp.makeConstraints {
			$0.top.equalTo(priceLabel.snp.bottom)
			$0.bottom.equalTo(infoView.snp.bottom)
			$0.trailing.equalTo(self.contentView)
			$0.leading.greaterThanOrEqualTo(infoView.snp.trailing)
		}
	}

	override func configureView() {
		ratingLabel.font = .boldSystemFont(ofSize: 25)
		ratingLabel.text = "-"

		priceLabel.text = "-"
		priceLabel.font = .systemFont(ofSize: 18)

		priceChangingLabel.text = "-"
		priceChangingLabel.font = .systemFont(ofSize: 15)
	}
}
