//
//  FavoriteCoinModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import Foundation
import RealmSwift

// 원래는 FavoriteModel이였는데, 혹여나 BuyCellCoin이 이친구를 갖고 있을때, 문제가 생길수도 있을 것 같아 하위 개념으로 뺐습니다. 그리고 다시 FavoriteModel 생성
class CoinModel: Object {
	@Persisted(primaryKey: true) var id: ObjectId
	@Persisted var coinName: String
	@Persisted var coinID: String
	@Persisted var coinSymbbol: String
	@Persisted var coinImageURL: String

	convenience init(coinName: String, coinID: String, coinSymbbol: String, coinImageURL: String) {
		self.init()
		self.coinName = coinName
		self.coinID = coinID
		self.coinSymbbol = coinSymbbol
		self.coinImageURL = coinImageURL
	}
}
