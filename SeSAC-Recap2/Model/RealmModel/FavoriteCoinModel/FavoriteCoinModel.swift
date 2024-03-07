//
//  FavoriteCoinModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

import Foundation
import RealmSwift

class FavoriteCoinModel: Object {
	@Persisted var id: ObjectId
	@Persisted var coin: CoinModel?
//	@Persisted var orderd: Int

	convenience init(coin: CoinModel) {
		self.init()
		self.coin = coin
	}
}
