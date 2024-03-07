//
//  FavoriteViewController.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit
import Kingfisher

class FavoriteViewController: BaseViewController {
	let favoriteView = FavoriteView()
	let realmModel = RealmViewModel()

	override func loadView() {
		self.view = favoriteView
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		realmModel.shared.viewAppearInput.value = .viewAppear
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		realmModel.shared.viewAppearInput.value = .viewDisappear
	}

	override func configureView() {
		navigationItem.title = "Favorite Coin"
		navigationController?.navigationBar.prefersLargeTitles = true
		setCollectionView()
	}

	override func configureBinding() {
		realmModel.dataChangeTrigger.bind { _ in
			self.favoriteView.collectionView.reloadData()
		}


		realmModel.shared.infoBind { value, retry in
			self.viewAppearAction(value, retry)
		}
//		realmModel.shared.viewAppearOutput.inse
//			.bind { value, retry in
//			self.viewAppearAction(value, retry)
//		}

		realmModel.didSelectOutput.bind { info, id in
			self.didSelectAction(info, id)
		}
	}

	private func viewAppearAction(_ value: DataSharingManager.ViewState?, _ retry: String?) {
		if let retry { self.showToast(.errorAndRetry, retry: retry) }
		guard value != nil else { return }
		self.favoriteView.collectionView.reloadData()
	}

	private func didSelectAction(_ info: CoinInfo?, _ id: String?) {
		let vc = DetailViewController()
		vc.viewModel.inPutCoinInfo.value = info
		vc.viewModel.inPutCoinId.value = id
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

//		realmModel.bind(withObject: FavoriteCoinModel.self) { [weak self] in
//			self?.collectionView.reloadData()
//		}
//		realmModel.isViewAppearOutput.bind { [weak self] value, retry in
//			if let retry {
//				self?.showToast(.errorAndRetry, retry: retry)
//			}
//
//			guard value != nil else { return }
//
//			guard let info = self?.realmModel.coinInfo else { return }
//			self?.collectionView.reloadData()
//		}
//		realmModel.collectionDidSelectOutput.bind { [weak self] info, id in
//			let vc = DetailViewController()
//			vc.viewModel.coinInfo.value = info
//			vc.viewModel.coinId.value = id
//			self?.navigationController?.pushViewController(vc, animated: true)
//		}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func setCollectionView() {
		favoriteView.collectionView.delegate = self
		favoriteView.collectionView.dataSource = self
		favoriteView.collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.description())
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return realmModel.favoriteCoinNumbersOfSection
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		realmModel.didSelectInput.value = realmModel.shared.favoriteCoins[indexPath.row].coin?.coinID
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.description(), for: indexPath) as! FavoriteCollectionViewCell
		let coin = realmModel.shared.favoriteCoins[indexPath.row].coin
		cell.infoView.coinNameLabel.text = coin?.coinName
		cell.infoView.symbolLabel.text = coin?.coinSymbbol
		cell.infoView.imageView.kf.setImage(with: realmModel.getURL(coin?.coinImageURL))
		cell.priceLabel.text = realmModel.setPriceLabel(withCoinID: coin?.coinID, kind: .price).value

		let priceChangingLabelData = realmModel.setPriceLabel(withCoinID: coin?.coinID, kind: .priceChanging)
		cell.priceChangingLabel.text = priceChangingLabelData.value

		if let priceChangingState = priceChangingLabelData.state {
			let color: UIColor
			let backColor: UIColor
			switch priceChangingState {
			case .plus:
				color = .colorRed
				backColor = .colorLightPink
			case .zero:
				color = .colorBlack
				backColor = .colorLightGray
			case .minus:
				color = .colorBlue
				backColor = .colorLightBlue
			}
			cell.priceChangingLabel.textColor = color
			cell.priceChangingLabel.backgroundColor = backColor
		}

		return cell
	}
}
