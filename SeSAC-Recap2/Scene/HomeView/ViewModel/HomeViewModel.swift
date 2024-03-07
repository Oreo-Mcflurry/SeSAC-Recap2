//
//  HomeViewModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/2/24.
//

import Foundation

class HomeViewModel {
	var coinTrend: CoinTrend?
	var coinTrendCallOutTrigger: Observable<Void?> = Observable(nil)

	init() {
		APIRequsetManager.shared.callRequest(type: CoinTrend.self, api: .trend) { result, error in
			if let result {
				self.coinTrend = result
				print(result)
				self.coinTrendCallOutTrigger.value = ()
			}
		}
	}


	enum HomeKind: String, CaseIterable {
		case favorite = "My Favorite"
		case topCoin = "Top 15 Coin"
		case topNft = "Top 7 NFT"

		var collectionViewType: CollectionViewType {
			switch self {
			case .favorite:
				return .favorite(isHorizontal: true)
			case .topCoin, .topNft:
				return .top
			}
		}
	}

	var numberOfRowsInSection: Int {
		return HomeKind.allCases.count
	}
}
