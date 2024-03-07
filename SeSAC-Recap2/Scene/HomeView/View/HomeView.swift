//
//  HomeVIew.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/1/24.
//

import UIKit
import SnapKit

/*
 TableView가 고정적이라면 여기서 TableView Cell들을 정의하고 넣었을거같은데..흠
 */
class HomeView: BaseUIView {
	let tableView = UITableView()
//	let favoriteCollectionView = CollectionHeaderLabelView()
//	let topCoinCollectionView = CollectionHeaderLabelView()
//	let topNftCollectionView = CollectionHeaderLabelView()

	override func configureHierarchy() {
		[tableView].forEach { self.addSubview($0) }
	}

	override func configureLayout() {
		tableView.snp.makeConstraints {
			$0.edges.equalTo(self)
		}
	}

	override func configureView() {
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.bounces = true
		tableView.contentInset = .zero
		tableView.translatesAutoresizingMaskIntoConstraints = false
	}

//	override func configureView() {
//		favoriteCollectionView.collectionViewType = .favorite
//		favoriteCollectionView.descriptionLabel.text = "My Favorite"
//
//		topCoinCollectionView.collectionViewType = .top
//		topCoinCollectionView.descriptionLabel.text = "Top 15 Coin"
//
//		topNftCollectionView.collectionViewType = .top
//		topNftCollectionView.descriptionLabel.text = "Top 7 NFT"

//	}
}
