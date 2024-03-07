//
//  CoinTrend.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import Foundation

struct CoinTrend: Decodable {
	let coins: [Coin]
	let nfts: [NFT]
}

struct Coin: Decodable {
	 let item: CoinItem
}

struct CoinItem: Decodable {
	let id: String
	let coinId: Int
	let name: String
	let symbol: String
	let marketRank: Int?
	let image: String
	let data: CointData

	enum CodingKeys: String, CodingKey {
		case id
		case coinId = "coin_id"
		case name
		case symbol
		case marketRank = "market_cap_rank"
		case image = "small"
		case data
	}
}

struct CointData: Decodable {
	let price: String
	let priceChanging: PriceChange

	enum CodingKeys: String, CodingKey {
		case price
		case priceChanging = "price_change_percentage_24h"
	}
}

struct PriceChange: Decodable {
	let krw: Double
}


struct NFT: Decodable {
	let name: String
	let symbol: String
	let image: String
	let data: NFTData

	enum CodingKeys: String, CodingKey {
		case name
		case symbol
		case image = "thumb"
		case data
	}
}

struct NFTData: Decodable {
	let price: String
	let priceChanging: String

	enum CodingKeys: String, CodingKey {
		case price = "floor_price"
		case priceChanging = "floor_price_in_usd_24h_percentage_change"
	}
}

