//
//  BuyCellCoinModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

import Foundation
import RealmSwift

class BuyCellCoinModel: Object {
	@Persisted var id: ObjectId
	@Persisted var purchasePrice: Double
	@Persisted var holds: Double

	@Persisted var coin: CoinModel?
}
