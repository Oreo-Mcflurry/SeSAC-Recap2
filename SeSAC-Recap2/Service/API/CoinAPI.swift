//
//  CoinAPI.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import Foundation
import Alamofire

enum CoinAPI {
	case trend
	case search(coinName: String)
	case coinInfo(coinIDs: [String]? = nil, favoriteCoin: [FavoriteCoinModel]? = nil)


	var getURL: URL {
		switch self {
		case .trend:
			return URL(string: "https://api.coingecko.com/api/v3/search/trending")!

		case .search:
			return URL(string: "https://api.coingecko.com/api/v3/search")!

		case .coinInfo:
			return URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
		}
	}

//	var type: AnyObject.Type {
//		 switch self {
//		 case .trend:
//			  return CoinTrend.self
//		 case .search(let coinName):
//			  return CoinSearch.self as AnyObject.Type // 강제로 타입 변환
	//		 case .coinData(let coinIDs, let unit):
	//			  return CoinTrend.self // CoinData 대신에 CoinTrend를 반환하던 것을 수정
	//		 }
	//	}

//	typealias ResponseType = Decodable // Default type
//
//	var responseType: ResponseType.Type {
//		switch self {
//		case .trend:
//			return CoinTrend.self
//		case .search:
//			return CoinSearch.self
//		case .coinInfo:
//			return CoinInfo.self
//		}
//	}

	var method: HTTPMethod {
		return .get
	}

	var parameter: Parameters {
		switch self {
		case .trend:
			return [:]
		case .search(let coinName):
			return ["query": coinName]
		case .coinInfo(let coinIDs, let favorite):
			var idString = ""

			if let favorite {
				for (index, item) in favorite.enumerated() {
					idString.append(item.coin?.coinID ?? "")
					if index != favorite.count-1 {
						idString.append(",")
					}
				}
			}

			if let coinIDs {
				for (index, item) in coinIDs.enumerated() {
					idString.append(item)
					if index != coinIDs.count-1 {
						idString.append(",")
					}
				}
			}
			return ["vs_currency": "krw", "ids": idString, "sparkline": "true", "locale":"ko"]
		}
	}
}
