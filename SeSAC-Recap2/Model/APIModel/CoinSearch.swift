//
//  CoinSearch.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import Foundation

struct CoinSearch: Decodable {
	let coins: [CoinSearchItem]
}

// 재사용이 가능한가 했더니 조금 다르군요
struct CoinSearchItem: Decodable {
	let id: String
	let name: String
	let symbol: String
	let image: String

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case symbol
		case image = "thumb"
	}
}
