//
//  HeaderCollectionView.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/1/24.
//

import UIKit
import SnapKit

class HeaderLabelTableViewCell: BaseTableViewCell {
	let descriptionLabel = UILabel()
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HeaderLabelTableViewCell.setCollectionViewLayout(.top))

	override func configureHierarchy() {
		[descriptionLabel, collectionView].forEach { self.contentView.addSubview($0) }
	}

	override func configureLayout() {
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(self.contentView).offset(15)
			$0.horizontalEdges.equalTo(self.contentView).inset(15)
		}

		collectionView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
			$0.horizontalEdges.bottom.equalTo(self.contentView)
			$0.height.equalTo((UIScreen.main.bounds.width)/1.5)
		}
	}

	override func configureView() {
		descriptionLabel.font = .boldSystemFont(ofSize: 20)
		collectionView.showsHorizontalScrollIndicator = false
	}
}

class FavoriteHeaderLabelTableViewCell: BaseTableViewCell {
	let descriptionLabel = UILabel()
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HeaderLabelTableViewCell.setCollectionViewLayout(.favorite(isHorizontal: true)))

	override func configureHierarchy() {
		[descriptionLabel, collectionView].forEach { self.contentView.addSubview($0) }
	}

	override func configureLayout() {
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(self.contentView)
			$0.horizontalEdges.equalTo(self.contentView).inset(15)
		}

		collectionView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
			$0.horizontalEdges.bottom.equalTo(self.contentView)
			$0.height.equalTo((UIScreen.main.bounds.width-15*2)/2)
		}
	}

	override func configureView() {
		descriptionLabel.font = .boldSystemFont(ofSize: 20)
		collectionView.showsHorizontalScrollIndicator = false
	}
}

// 하나로 합치려 하니까 잘 안되네요
//class HeaderLabelTableViewCell: BaseTableViewCell {
//	var collectionViewType: CollectionViewType = .favorite(isHorizontal: true)
//	let descriptionLabel = UILabel()
//	lazy var collectionView: UICollectionView = {
//		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HeaderLabelTableViewCell.setCollectionViewLayout(collectionViewType))
//		return collectionView
//	}()
//
//	override func configureHierarchy() {
//		[descriptionLabel, collectionView].forEach { self.addSubview($0) }
//	}
//
//	override func configureLayout() {
//		descriptionLabel.snp.makeConstraints {
//			$0.top.horizontalEdges.equalTo(self)
//		}
//
//		collectionView.snp.makeConstraints {
//			$0.top.equalTo(descriptionLabel.snp.bottom)
//			$0.horizontalEdges.bottom.equalTo(self)
//			$0.height.equalTo(500)
//		}
//	}
//
//	override func configureView() {
//		descriptionLabel.font = .boldSystemFont(ofSize: 20)
//	}
//}
