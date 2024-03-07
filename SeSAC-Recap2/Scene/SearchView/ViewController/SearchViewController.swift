//
//  SearchViewModel.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewController: BaseViewController {

	let viewModel = SearchViewModel()
	let realmModel = RealmViewModel()
	let searchBar = UISearchBar()
	let tableView = UITableView()

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func configureHierarchy() {
		[searchBar,tableView].forEach { view.addSubview($0) }
	}

	override func configureLayout() {
		searchBar.snp.makeConstraints {
			$0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}

		tableView.snp.makeConstraints {
			$0.top.equalTo(searchBar.snp.bottom)
			$0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		navigationItem.title = "Search"
		navigationController?.navigationBar.prefersLargeTitles = true
		setTableView()
		setSearchBar()
	}

	override func configureBinding() {
		viewModel.searchOutput.bind { retry, isNoData in
			self.searchAction(retry, isNoData)
		}

		realmModel.dataChangeTrigger.bind { _ in
			self.tableView.reloadData()
		}

		realmModel.starOutput.bind { value, error in
			self.starAction(value, error)
		}

		viewModel.isEditingOutput.bind { value in
			self.editAction(value)
		}

		realmModel.didSelectOutput.bind { coinInfo, coinID in
			self.didSelectAction(coinInfo, coinID)
		}
	}

	private func didSelectAction(_ coinInfo: CoinInfo?, _ coinID: String?) {
		let vc = DetailViewController()
		vc.viewModel.inPutCoinInfo.value = coinInfo
		vc.viewModel.inPutCoinId.value = coinID
		self.navigationController?.pushViewController(vc, animated: true)
	}

	private func editAction(_ value: Bool?) {
		if let value {
			self.searchBar.setShowsCancelButton(value, animated: true)
		}
	}

	private func searchAction(_ retry: String?, _ isNoData: Bool?) {
		if let retry {
			self.showToast(.decodingError, retry: retry)
		}
		if let isNoData, isNoData {
			self.showToast(.searchResultIsEmpty)
		}
		self.tableView.reloadData()
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

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	func setTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.description())
		tableView.rowHeight = UITableView.automaticDimension
		tableView.separatorStyle = .none
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRowsInSection
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.description(), for: indexPath) as! SearchTableViewCell

		let coin = viewModel.searchList.coins[indexPath.row]
		cell.infoView.imageView.kf.setImage(with: realmModel.getURL(coin.image))
		cell.infoView.coinNameLabel.attributedText = NSAttributedString.attributedRed(withFullString: coin.name, of: searchBar.text!)
		cell.infoView.symbolLabel.text = coin.symbol
		cell.starButton.setImage(realmModel.setStarImage(withCoinID: coin.id) , for: .normal)
		cell.starButton.addTarget(self, action: #selector(starButtonClicked), for: .touchUpInside)
		cell.starButton.tag = indexPath.row
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		realmModel.didSelectInput.value = viewModel.searchList.coins[indexPath.row].id
	}

	@objc func starButtonClicked(sender: UIButton) {
//		viewModel.starInput.value = sender.tag
		let coin = viewModel.searchList.coins[sender.tag]
		realmModel.starInput.value = CoinModel(coinName: coin.name, coinID: coin.id, coinSymbbol: coin.symbol, coinImageURL: coin.image)
	}
}

extension SearchViewController: UISearchBarDelegate {
	func setSearchBar() {
		searchBar.searchBarStyle = .minimal
		searchBar.placeholder = "코인을 검색하세요"
		searchBar.delegate = self
	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		viewModel.isEditingInput.value = true
	}

	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		viewModel.isEditingInput.value = false
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		viewModel.searchTextInput.value = searchBar.text!
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}
}
