//
//  CoinInfo.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

import Foundation

struct CoinInfo: Decodable {
	 let coinId: String
	 let symbol: String
	 let name: String
	 let image: String
	 let currentPrice: Double
	 let marketCap: Double
	 let marketCapRank: Int
	 let totalVolume: Double
	 let high24H: Double
	 let low24H: Double
	 let priceChangePercentage24H: Double
	 let ath: Double
	 let athDate: String
	 let atl: Double
	 let atlDate: String
	 let lastUpdated: String
	 let sparklineIn7D: SparklineIn7D

	 enum CodingKeys: String, CodingKey {
		  case coinId = "id"
		  case symbol = "symbol"
		  case name = "name"
		  case image = "image"
		  case currentPrice = "current_price"
		  case marketCap = "market_cap"
		  case marketCapRank = "market_cap_rank"
		  case totalVolume = "total_volume"
		  case high24H = "high_24h"
		  case low24H = "low_24h"
		  case priceChangePercentage24H = "price_change_percentage_24h"
		  case ath = "ath"
		  case athDate = "ath_date"
		  case atl = "atl"
		  case atlDate = "atl_date"
		  case lastUpdated = "last_updated"
		  case sparklineIn7D = "sparkline_in_7d"
	 }
}

struct SparklineIn7D: Decodable {
	 let price: [Double]
}
