//
//  ChartViewController.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/29/24.
//

import UIKit
import Kingfisher
import SnapKit

// 최대한 Request를 덜하게 하려고 이렇게 저렇게 데이터를 재사용 하려고 했는데, 도저히 코드를 어떻게 이쁘게 설계해야 할지 모르겠어요.
// 그냥 정적인 데이터라면 이런식으로 쉽게 할 수 있었을거같은데, 주기적으로 업데이트를 해줄 것까지 생각하다보니, 이게 영..

class DetailViewController: BaseViewController {

	deinit {
		print("Deinit")
	}

	// CollectionView로 할까 그냥 UIView로 할까 고민하다가, 그냥 UIView로 하기로 결정했습니다.
	let detailView = DetailView()
	let viewModel = DetailViewModel()
	let realmModel = RealmViewModel()

	override func loadView() {
		self.view = detailView
	}

	override func viewDidDisappear(_ animated: Bool) {
		viewModel.viewDidDisappearInput.value = ()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.viewAppearInput.value = ()
	}

	override func configureView() {
		navigationItem.largeTitleDisplayMode = .never
		setNavigationButton()
	}

	override func configureBinding() {
		realmModel.starOutput.bind { [weak self] value, error in
			self?.starAction(value, error)
		}

		viewModel.coinInfoOutPut.bind { [weak self] coin, retry in
			self?.coinInfoAction(coin, retry)
		}
	}

	func setNavigationButton() {
		let rightStarButton = UIBarButtonItem(image: realmModel.setStarImage(withCoinID: viewModel.inPutCoinInfo.value?.coinId), style: .plain, target: self, action: #selector(starButtonClicked))
		navigationItem.rightBarButtonItem = rightStarButton
	}

	@objc func starButtonClicked() {
		guard let coin = viewModel.coinInfo else { return }
		realmModel.starInput.value = CoinModel(coinName: coin.name, coinID: coin.coinId, coinSymbbol: coin.symbol, coinImageURL: coin.image)
		setNavigationButton()
	}

	private func coinInfoAction(_ coin: CoinInfo?, _ retry: String?) {
		if let retry { self.showToast(.errorAndRetry, retry: retry) }
		if let coin { self.inputValueInView(coin: coin) }
	}

	private func starAction(_ value: Bool?, _ error: RealmRepositoryManager.RealmError?) {
		if let error, error == .isMax {
			self.showToast(.favoriteError)
			return
		}
		if let value {
			self.showToast(value ? .favoriteAdd : .favoriteDelete)
		}
	}

	private func inputValueInView(coin: CoinInfo) {
		detailView.coinName.text = coin.name
		detailView.coinImage.kf.setImage(with: URL(string: coin.image)!)
		detailView.priceLabel.text = NumberFormatter.setPrice(coin.currentPrice, kind: .price).value
		detailView.highLabelView.priceLabel.text = NumberFormatter.setPrice(coin.high24H, kind: .price).value
		detailView.lowLabelView.priceLabel.text = NumberFormatter.setPrice(coin.low24H, kind: .price).value
		detailView.allHighView.priceLabel.text = NumberFormatter.setPrice(coin.ath, kind: .price).value
		detailView.allLowView.priceLabel.text = NumberFormatter.setPrice(coin.atl, kind: .price).value
		detailView.setUpChart(viewModel.entrys)

		let priceChangingData = NumberFormatter.setPrice(coin.priceChangePercentage24H, kind: .priceChanging)
		detailView.priceChangingLabel.text = priceChangingData.value

		if let priceChangingState = priceChangingData.state {
			let color: UIColor
			switch priceChangingState {
			case .plus:
				color = .colorRed
			case .zero:
				color = .colorBlack
			case .minus:
				color = .colorBlue
			}
			detailView.priceChangingLabel.textColor = color
		}
	}
}

//	func setDataCount(_ count: Int, range: UInt32) {
//		 let values = (0..<count).map { (i) -> ChartDataEntry in
//			  let val = Double(arc4random_uniform(range) + 3)
//			  return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
//		 }
//
//		 let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
//		 set1.drawIconsEnabled = false
//		 setup(set1)
//
//		 let value = ChartDataEntry(x: Double(3), y: 3)
//		 set1.addEntryOrdered(value)
//		 let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//									  ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//		 let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//		 set1.fillAlpha = 1
//		 set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
//		 set1.drawFilledEnabled = true
//
//		 let data = LineChartData(dataSet: set1)
//
//		 chartView.data = data
//	}
