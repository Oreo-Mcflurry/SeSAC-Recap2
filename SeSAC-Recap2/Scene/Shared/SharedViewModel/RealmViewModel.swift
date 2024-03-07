//
//  ReamViewModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/1/24.
//

import Foundation
import RealmSwift
import UIKit.UIImage

class RealmViewModel {
	let shared = DataSharingManager.shared
	private var token : NotificationToken?

	var dataChangeTrigger: Observable<Void?> = Observable(nil)

	var starInput: Observable<CoinModel?> = Observable(nil)
	var starOutput: Observable<(Bool?, RealmRepositoryManager.RealmError?)> = Observable((nil, nil))

	var didSelectInput: Observable<String?> = Observable(nil)
	var didSelectOutput: Observable<(CoinInfo?, String?)> = Observable((nil, nil))

	// MARK: - Init
	init() {
		token = shared.favoriteCoins.observe { [weak self] changes in
			self?.tokenAction(changes)
		}

		starInput.bind { [weak self] coin in
			self?.starAction(coin)
		}

		didSelectInput.bind { [weak self] value in
			self?.didSelectAction(value)
		}

	}

	// MARK: - Usage
	func getURL(_ url: String?) -> URL {
		return URL(string: url ?? "https://i.namu.wiki/i/oeg0SrZ7dtO3PDuKHOHM0QAHodKoWCyGoL-YwQpfHSODs6Ld8jPC4zbss9wSuorssi3YZWzIrdoetRrV5SjBow.webp")!
	}

	func setPriceLabel(withCoinID id: String?, kind: priceKind) -> (value: String, state: PriceState?) {
		
		if let coinInfo = shared.coinInfo.first(where: {$0.coinId == id }) {
			return kind == .price ? NumberFormatter.setPrice(coinInfo.currentPrice, kind: kind) : NumberFormatter.setPrice(coinInfo.priceChangePercentage24H, kind: .priceChanging)
		}
		return ("-", nil)
	}

	func setStarImage(withCoinID id: String?) -> UIImage {
		guard let id else { return .btnStar }

		for item in shared.favoriteCoins where item.coin?.coinID == id {
			return .btnStarFill
		}
		return .btnStar
	}

	func isSaved(_ id: String) -> Bool {
		let manager = RealmRepositoryManager()
		return manager.isSaved(withCoinID: id)
	}

	var favoriteCoinNumbersOfSection: Int {
		return shared.favoriteCoins.count
	}

	var isAppearFavoriteViewInHomeView: Bool {
		return shared.favoriteCoins.count >= 2
	}

	// MARK: - Binding Action
	private func tokenAction(_ changes: RealmCollectionChange<Results<FavoriteCoinModel>>) {
		switch changes {
		case .initial, .update:
			self.dataChangeTrigger.value = ()
		case .error:
			break;
		}
	}

	private func starAction(_ coin: CoinModel?) {
		guard let coin else { return }

		let manager = RealmRepositoryManager()
		if !manager.isSaved(withCoinID: coin.coinID) {
			let newData = FavoriteCoinModel(coin: coin)
			do {
				try manager.createData(newData)
				self.starOutput.value = (true, nil)
			} catch {
				self.starOutput.value = (true, .isMax)
			}
		} else {
			manager.deleteFavorite(withCoinID: coin.coinID)
			self.starOutput.value = (false, nil)
		}
	}

	private func didSelectAction(_ value: String?) {
		if let item = self.shared.coinInfo.first(where: { $0.coinId == value }) {
			self.didSelectOutput.value = (item, nil)
			return
		}
		self.didSelectOutput.value = (nil, value)
	}
}
