//
//  HomeViewController.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit
import Kingfisher

/*
 문제 1. 데이터는 잘 들어오는데, 콜렉션뷰를 컨트롤하는 과정에서 tag가 잘 안붙고,numberOfItemsInSection은 무조건 0번 콜렉션뷰를,  cellForItemAt은 1,2를 잘 가져가는 문제가 발생. 도대체 무슨 문제인지 알수가 없습니다.
 */

class HomeViewController: BaseViewController {
	let homeView = HomeView()
	let viewModel = HomeViewModel()
	let realmModel = RealmViewModel()

	typealias HomeTableKind = HomeViewModel.HomeKind

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		realmModel.shared.viewAppearInput.value = .viewAppear
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		realmModel.shared.viewAppearInput.value = .viewDisappear
	}

	override func loadView() {
		self.view = homeView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func configureBinding() {
		realmModel.dataChangeTrigger.bind { _ in
			self.homeView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
		}

		realmModel.didSelectOutput.bind { info, id in
			self.didSelectAction(info, id)
		}

		realmModel.shared.infoBind { value, retry in
			self.viewAppearAction(value, retry)
		}

		viewModel.coinTrendCallOutTrigger.bind { _ in
			self.homeView.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
			self.homeView.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
		}
	}

	override func configureView() {
		navigationItem.title = "Crypto Coin"
		navigationController?.navigationBar.prefersLargeTitles = true
		setTableView()
	}

	private func didSelectAction(_ coinInfo: CoinInfo?, _ coinID: String?) {
		let vc = DetailViewController()
		vc.viewModel.inPutCoinInfo.value = coinInfo
		vc.viewModel.inPutCoinId.value = coinID
		self.navigationController?.pushViewController(vc, animated: true)
	}

	private func viewAppearAction(_ value: DataSharingManager.ViewState?, _ retry: String?) {
		if let retry { self.showToast(.errorAndRetry, retry: retry) }
		guard value != nil else { return }
		self.homeView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
	}
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRowsInSection
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 && !realmModel.isAppearFavoriteViewInHomeView {
			let cell = UITableViewCell()
//			tableView.rowHeight = 0
			return cell
		} else if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteHeaderLabelTableViewCell.description(), for: indexPath) as! FavoriteHeaderLabelTableViewCell
			tableView.rowHeight = UITableView.automaticDimension
			cell.descriptionLabel.text = HomeTableKind.allCases[indexPath.row].rawValue
			cell.collectionView.delegate = self
			cell.collectionView.dataSource = self
			cell.collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.description())
			cell.collectionView.tag = indexPath.row
			tableView.rowHeight = UITableView.automaticDimension
			cell.collectionView.reloadData()
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: HeaderLabelTableViewCell.description(), for: indexPath) as! HeaderLabelTableViewCell
			tableView.rowHeight = UITableView.automaticDimension
			cell.descriptionLabel.text = HomeTableKind.allCases[indexPath.row].rawValue
			cell.collectionView.delegate = self
			cell.collectionView.dataSource = self
			cell.collectionView.register(TopCollectionCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionCollectionViewCell.description())
			cell.collectionView.tag = indexPath.row
			cell.collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
			tableView.rowHeight = UITableView.automaticDimension
			return cell
		}
	}

	private func setTableView() {
		homeView.tableView.delegate = self
		homeView.tableView.dataSource = self
		homeView.tableView.register(HeaderLabelTableViewCell.self, forCellReuseIdentifier: HeaderLabelTableViewCell.description())
		homeView.tableView.register(FavoriteHeaderLabelTableViewCell.self, forCellReuseIdentifier: FavoriteHeaderLabelTableViewCell.description())
	}
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		switch collectionView.tag {
		case 0: return realmModel.favoriteCoinNumbersOfSection
		case 1: 
			guard let count = viewModel.coinTrend?.coins.count else { return 0 }
			return count
		case 2:
			guard let count = viewModel.coinTrend?.nfts.count else { return 0 }
			return count
		default:
			return 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView.tag == 0 {
			realmModel.didSelectInput.value = realmModel.shared.favoriteCoins[indexPath.row].coin?.coinID
		} else if collectionView.tag == 1 {
			realmModel.didSelectInput.value = viewModel.coinTrend?.coins[indexPath.row].item.id
		}

	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView.tag == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.description(), for: indexPath) as! FavoriteCollectionViewCell
			let coin = realmModel.shared.favoriteCoins[indexPath.item].coin
			cell.infoView.coinNameLabel.text = coin?.coinName
			cell.infoView.imageView.kf.setImage(with: realmModel.getURL(coin?.coinImageURL))
			cell.infoView.symbolLabel.text = coin?.coinSymbbol
			cell.priceLabel.text = realmModel.setPriceLabel(withCoinID: coin?.coinID, kind: .price).value

			let priceChangingLabelData = realmModel.setPriceLabel(withCoinID: coin?.coinID, kind: .priceChanging)
			cell.priceChangingLabel.text = priceChangingLabelData.value

			if let state = priceChangingLabelData.state {
				let color: UIColor
				switch state {
				case .minus:
					color = .colorBlue
				case .plus:
					color = .colorRed
				case .zero:
					color = .colorBlack
				}
				cell.priceChangingLabel.textColor = color
			}

			return cell
		} else if collectionView.tag == 1 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionCollectionViewCell.description(), for: indexPath) as! TopCollectionCollectionViewCell
			cell.ratingLabel.text = "\(indexPath.item+1)"

			let item = viewModel.coinTrend?.coins[indexPath.item].item
			cell.infoView.coinNameLabel.text = item?.name
			cell.infoView.symbolLabel.text = item?.symbol
			cell.infoView.imageView.kf.setImage(with: realmModel.getURL(item?.image))
			cell.priceLabel.text = item?.data.price

			let priceChangingLabelData = NumberFormatter.setPrice(item?.data.priceChanging.krw ?? 0, kind: .priceChanging)
			cell.priceChangingLabel.text = priceChangingLabelData.value
			if let priceChangingState = priceChangingLabelData.state {
				let color: UIColor
				switch priceChangingState {
				case .plus:
					color = .colorRed
				case .zero:
					color = .colorBlack
				case .minus:
					color = .colorBlue
				}
				cell.priceChangingLabel.textColor = color
			}
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionCollectionViewCell.description(), for: indexPath) as! TopCollectionCollectionViewCell
			cell.ratingLabel.text = "\(indexPath.item+1)"

			let item = viewModel.coinTrend?.nfts[indexPath.item]
			cell.infoView.coinNameLabel.text = item?.name
			cell.infoView.symbolLabel.text = item?.symbol
			cell.infoView.imageView.kf.setImage(with: realmModel.getURL(item?.image))
			cell.priceLabel.text = item?.data.price

			let priceChangingLabelData = NumberFormatter.setPrice(Double((item?.data.priceChanging) ?? "0") ?? 0, kind: .priceChanging)
			cell.priceChangingLabel.text = priceChangingLabelData.value
			if let priceChangingState = priceChangingLabelData.state {
				let color: UIColor
				switch priceChangingState {
				case .plus:
					color = .colorRed
				case .zero:
					color = .colorBlack
				case .minus:
					color = .colorBlue
				}
				cell.priceChangingLabel.textColor = color
			}
			return cell
		}
	}

}
