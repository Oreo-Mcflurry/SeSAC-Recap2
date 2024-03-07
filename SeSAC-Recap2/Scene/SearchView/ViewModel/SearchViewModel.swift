//
//  SearchViewModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import Foundation

class SearchViewModel {
	var searchList: CoinSearch = CoinSearch(coins: [])

	var searchTextInput = Observable("")
	var searchOutput: Observable<(String?, Bool?)> = Observable((nil, nil))

	var isEditingInput: Observable<Bool?> = Observable(nil)
	var isEditingOutput: Observable<Bool?> = Observable(nil)

	init() {
		isEditingInput.bind { value in
			self.isEditingOutput.value = value
		}

		searchTextInput.bind { text in
			APIRequsetManager.shared.callRequest(type: CoinSearch.self, api: .search(coinName: text)) { result, error in
				if let error {
					switch error {
					case .decodingError(let retry):
						self.searchOutput.value = (retry, self.searchList.coins.isEmpty)
					}
					return
				} else if let result {
					self.searchList = result
					self.searchOutput.value = (nil, self.searchList.coins.isEmpty)
					return
				}
			}
		}
	}

	var numberOfRowsInSection: Int {
		return searchList.coins.count
	}
}
