//
//  FavoriteView.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/2/24.
//

import UIKit

class FavoriteView: BaseUIView {
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout(.favorite(isHorizontal: false)))

	override func configureHierarchy() {
		self.addSubview(collectionView)
	}

	override func configureLayout() {
		collectionView.snp.makeConstraints {
			$0.edges.equalTo(self.safeAreaLayoutGuide)
		}
	}
}
