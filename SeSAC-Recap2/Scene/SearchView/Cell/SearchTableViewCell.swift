//
//  SearchCell.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit
import SnapKit

class SearchTableViewCell: BaseTableViewCell {
	let infoView = CoinInfoUIView()
	let starButton = UIButton()

	override func configureHierarchy() {
		[infoView, starButton].forEach { self.contentView.addSubview($0) }
	}

	override func configureLayout() {
		infoView.snp.makeConstraints {
			$0.verticalEdges.leading.equalTo(self.contentView).inset(10)
		}

		starButton.snp.makeConstraints {
			$0.trailing.verticalEdges.equalTo(self.contentView).inset(10)
			$0.leading.greaterThanOrEqualTo(infoView.snp.trailing).offset(10)
		}
	}
}
