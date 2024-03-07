//
//  APIRequsetManager.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import Foundation
import Alamofire

class APIRequsetManager {
	static let shared = APIRequsetManager()
	private init() { }

	enum APIError {
//		case serverError
		case decodingError(retry: String)
	}

	func callRequest<T: Decodable>(type: T.Type, api: CoinAPI, _ completionHandler: @escaping (T?, APIError?)->Void) {
		AF.request(api.getURL, method: api.method, parameters: api.parameter).responseDecodable(of: T.self) { response in
//			debugPrint(response)

			// Seach의 경우 캐시 안지워도 될거같긴 한데.. 정신건강에 좋은 방법을 택했습니다.
			URLCache.shared.removeAllCachedResponses()
			switch response.result {
			case .success(let success):
				completionHandler(success, nil)
				return
			case .failure(_):
				if let retryAfter = response.response?.allHeaderFields["retry-after"] as? String {
//					print(retryAfter)
					completionHandler(nil, .decodingError(retry: retryAfter))
				} else {
					completionHandler(nil, .decodingError(retry: "15"))
				}
			}
		}
	}

	// CoinAPi만 적어도 type을 알아서 뱉어서 자동으로 되게끔 하고싶은데 잘 안되요

//	func createRequest(api: CoinAPI) {
//
//	}
//	func callRequest(api: CoinAPI, _ completionHandler: @escaping (CoinAPI.ResponseType?, APIError?)->Void) {
////		typealias ResponseType = CoinAPI.ResponseType
//		AF.request(api.getURL, method: api.method, parameters: api.parameter).responseDecodable(of: api.responseType) { response in
////			debugPrint(response)
//			switch response.result {
//			case .success(let success):
//				completionHandler(success, nil)
//				return
//			case .failure(let fail):
//				print(fail)
//				completionHandler(nil, .decodingError)
//				return
//			}
//		}
//		completionHandler(nil, .serverError)
//	}
}
