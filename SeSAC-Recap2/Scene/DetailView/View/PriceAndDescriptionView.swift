//
//  PriceAndDescriptionView.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/29/24.
//

import UIKit
import SnapKit

class PriceAndDescriptionView: BaseUIView {
	let descriptionLabel = UILabel()
	let priceLabel = UILabel()

	override func configureHierarchy() {
		[descriptionLabel, priceLabel].forEach { self.addSubview($0) }
	}

	override func configureLayout() {
		descriptionLabel.snp.makeConstraints {
			$0.top.horizontalEdges.equalTo(self)
		}

		priceLabel.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
			$0.bottom.horizontalEdges.equalTo(self)
		}
	}

	override func configureView() {
		descriptionLabel.font = .boldSystemFont(ofSize: 20)
		priceLabel.font = .systemFont(ofSize: 20)
	}
}
