//
//  RealmDataShared.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/1/24.
//

import Foundation
import RealmSwift

class DataSharingManager {
	static let shared = DataSharingManager()

	var coinInfo: [CoinInfo] = []
	var favoriteCoins: Results<FavoriteCoinModel>!
	var buyCoins: Results<BuyCellCoinModel>!

	var timer: Timer?

	enum ViewState {
		case viewAppear
		case viewDisappear
	}

	var viewAppearInput: Observable<ViewState?> = Observable(nil)
//	var viewAppearOutput: Observable<(ViewState?, String?)> = Observable((nil, nil))
	private var viewAppearOutActions: [(ViewState?, String?)->Void] = []

	private init() {
		let realm = try! Realm()
		favoriteCoins = realm.objects(FavoriteCoinModel.self)
		buyCoins = realm.objects(BuyCellCoinModel.self)

		viewAppearInput.bind { state in
			self.viewAppearAction(state)
		}
	}

	func infoBind(_ newAction: @escaping (ViewState?, String?)->Void) {
		viewAppearOutActions.append(newAction)
	}

	private func occurEvent(_ values: (ViewState?, String?)) {
		for action in viewAppearOutActions {
			action(values.0, values.1)
		}
	}

	private func startFetchingCoinInfo() {
		callRepeatRequest()
		timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(callRepeatRequest), userInfo: nil, repeats: true)
	}

	private func stopFetchingCoinInfo() {
		timer?.invalidate()
		self.occurEvent((.viewDisappear, nil))
	}

	@objc private func callRepeatRequest() {
		APIRequsetManager.shared.callRequest(type: [CoinInfo].self, api: .coinInfo(favoriteCoin: Array(favoriteCoins))) { result, error in
			if let error {
				switch error {
				case .decodingError(let retry):
					self.occurEvent((nil, retry))
				}
			} else if let result {
				self.coinInfo = result
			}
			self.occurEvent((.viewAppear, nil))
		}
	}

	func viewAppearAction(_ state: DataSharingManager.ViewState?) {
		guard let state else { return }
		switch state {
		case .viewAppear:
			self.startFetchingCoinInfo()
		case .viewDisappear:
			self.stopFetchingCoinInfo()
		}
	}

}
