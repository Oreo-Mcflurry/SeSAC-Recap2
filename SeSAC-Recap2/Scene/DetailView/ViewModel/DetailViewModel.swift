//
//  DetailViewModek.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/29/24.
//

import Foundation
import DGCharts

class DetailViewModel {
	var inPutCoinInfo: Observable<CoinInfo?> = Observable(nil)
	var inPutCoinId: Observable<String?> = Observable(nil)
	var coinInfoOutPut: Observable<(CoinInfo?, String?)> = Observable((nil, nil))

	var viewDidDisappearInput: Observable<Void?> = Observable(nil)
	var viewAppearInput: Observable<Void?> = Observable(nil)

	var entrys: [ChartDataEntry] = []
	var coinId: String = ""
	var coinInfo: CoinInfo?

	var timer: Timer?

	init() {
		inPutCoinId.bind { [weak self] coinId in
			guard let coinId else { return }
			self?.coinId = coinId
			self?.startFetchingCoinInfo()
		}

		inPutCoinInfo.bind { [weak self] coinInfo in
			guard let coinInfo else { return }

			self?.viewAppearInput.bind{ _ in
				self?.coinInfoOutPut.value = (coinInfo, nil)
				self?.coinInfo = coinInfo
				self?.coinId = coinInfo.coinId
				self?.startFetchingCoinInfo()
			}
		}

		viewDidDisappearInput.bind { [weak self] _ in
			self?.stopFetchingCoinInfo()
		}
	}

	@objc private func callRepeatRequest() {
		APIRequsetManager.shared.callRequest(type: [CoinInfo].self, api: .coinInfo(coinIDs: [self.coinId])) { result, error in
			if let error {
				switch error {
				case .decodingError(let retry):
					self.coinInfoOutPut.value = (nil, retry)
				}
			} else if let result {
				self.coinInfoOutPut.value = (result.first, nil)
				self.coinInfo = result.first
				if let sparkLine = result.first?.sparklineIn7D.price {
					for (index, item) in sparkLine.enumerated() {
						self.entrys.append(ChartDataEntry(x: Double(index), y: item))
					}
				}
			}
		}
	}

	private func startFetchingCoinInfo() {
		callRepeatRequest()
		timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(callRepeatRequest), userInfo: nil, repeats: true)
	}

	private func stopFetchingCoinInfo() {
		timer?.invalidate()
	}

}
