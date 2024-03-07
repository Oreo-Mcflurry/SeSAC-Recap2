//
//  DBObserver.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

//import Foundation
//import UIKit.UIImage
//import RealmSwift

/*
 아.. 뷰모델은 싱글톤으로 구성하면 안되겠구나... 라는 생각을 했습니다.
 싱글톤을 사용한 이유는,
 1. 뷰마다 데이터가 달라질 것을 우려해서.
 2. TabbarView로 인해 떨어져 있는 tableView나 Collection뷰들이 한꺼번에 Reload되면 좋을것 같아서.
 3. 비슷한 기능들을 하는 Function들이 많아서.

 그 이유로 싱글톤으로 구성하였는데,, 다음과 같은 문제들이 생겼습니다.

 1. didSelectInput, collectionDidSelectInput 처럼 어처피 갯수가 많아진다. -> 이걸 해결하기 위해서 ViewDidLoad가 아닌 ViewWillApear등에 bind를 하는 등의 대처를 할 수 있겠지만, 뭐랄까요... 구멍난 배에 테이프로 막는 느낌입니다.. 여기까지 생각이 미쳐 닿지 않았네요.
 2. 결국에는 뷰마다 비슷한 기능들을 하는 Observable들을 중복 선언하게 된다.
 3. viewModel을 하나의 뷰에 여러번 사용하려다보니 서로간의 소통이 필요한 지점에서 애 먹게 된다. -> ViewModel안에 RealmViewModel을 선언하는 방법도 있겠지만, 여전히 맘에 들진 않습니다. 책임을 나누려고 한거였는데, 그렇지 못하게 된거니까요.
 4. private var closures: [(className: AnyClass, action: (()->Void))] = [] 이부분도 문제가 생겼습니다. 같은 뷰를 여러 탭에서 띄울수가 있는데, Binding이 무시되어버리는 문제가 생깁니다.

 ㅎㅁㅎ.....
 한숨 자면서 대안을 생각해보았을때,
 1. 데이터 자체 부분은 싱글톤으로 구성한다. +) 주기적으로 데이터를 Fetching하는 부분도 같이 제공
 2. ViewModel은 싱글톤이 아닌 인스턴스화 한다.
 3. ViewModel은 Data Singleton을 소유한다.
 4. NotificationToken을 누가 갖고 있어야 하는가가 제일 고민입니다. 싱글톤이 갖고 있고 데이터가 변경 되었을떄 여러 뷰모델에 이벤트를 전달하는 방식으로 구현할지, 아에 뷰모델이 갖고 있어서 데이터를 직접적으로 관찰하는 형태로 할지 고민이였습니다.
 -> 싱글톤이 NotificationToken을 갖고 있으면 여러 뷰를 왔다갔다 했을때, 그리고 위의 문제인 같은 뷰를 여러 탭에서 띄웠을때의 문제를 대비할수가 없다는 결론, 뷰모델이 직접 싱글톤의 데이터를 관찰하는 형태로 구현해보겠습니다.

 처음에 과제를 받자마자 이 RealmViewModel의 형태를 떠올렸었는데, 눈물이 나네요..
 */

//class RealmViewModel {
//	static let shared = RealmViewModel()
//
//	private var closures: [(className: AnyClass, action: (()->Void))] = []
//	private var token : NotificationToken?
//
//	var favoriteCoins: Results<FavoriteCoinModel>!
//	var buyCoins: Results<BuyCellCoinModel>!
//
//	var coinInfo: [CoinInfo] = []
//
//	var timer: Timer?
//
//	//	var starInput: Observable<(CoinSearchItem?, Int?)> = Observable((nil, nil))
//	var starInput: Observable<CoinSearchItem?> = Observable(nil)
//	var starOutput: Observable<(Bool?, RealmRepositoryManager.RealmError?)> = Observable((nil, nil))
//
//	var isViewAppearInput: Observable<Bool?> = Observable(nil)
//	var isViewAppearOutput: Observable<(Bool?, String?)> = Observable((nil, nil))
//
////	var didSelectInput: Observable<IndexPath?> = Observable(nil)
//	var didSelectInput: Observable<String?> = Observable(nil)
//	var didSelectOutput: Observable<(CoinInfo?, String?)> = Observable((nil, nil))
//
//	var collectionDidSelectInput: Observable<String?> = Observable(nil)
//	var collectionDidSelectOutput: Observable<(CoinInfo?, String?)> = Observable((nil, nil))
//
//	private init() {
////		let realm = try! Realm()
////		favoriteCoins = realm.objects(FavoriteCoinModel.self)
////		buyCoins = realm.objects(BuyCellCoinModel.self)
////
////		token = favoriteCoins.observe { changes in
////			switch changes {
////			case .initial, .update:
////				self.occurEvent()
////			case .error(let error):
////				print(error)
////			}
////		}
//
////		isViewAppearInput.bind { value in
////			guard let value else { return }
////
////			if value {
////				self.startFetchingCoinInfo()
////			} else {
////				self.stopFetchingCoinInfo()
////			}
////		}
//
////		starInput.bind { coin in
////			guard let coin else { return }
////
////			let manager = RealmRepositoryManager()
////
////			if !manager.isSaved(withCoinID: coin.id) {
////				let newData = FavoriteCoinModel(coin: CoinModel(coinName: coin.name, coinID: coin.id, coinSymbbol: coin.symbol, coinImageURL: coin.image))
//////				self.saveImageToDocument(image: image, withId: coin.id)
////				do {
////					try manager.createData(newData)
////					self.starOutput.value = (true, nil)
////				} catch {
////					self.starOutput.value = (true, .isMax)
////				}
////			} else {
//////				self.removeImageFromDocument(withId: coin.id)
////				manager.deleteFavorite(withCoinID: coin.id)
////				self.starOutput.value = (false, nil)
////			}
////		}
//
//		didSelectInput.bind { value in
//			if let item = self.coinInfo.first(where: { $0.coinId == value }) {
//				self.didSelectOutput.value = (item, nil)
//				return
//			}
//			self.didSelectOutput.value = (nil, value)
//		}
//
//		collectionDidSelectInput.bind { value in
//			if let item = self.coinInfo.first(where: { $0.coinId == value }) {
//				self.collectionDidSelectOutput.value = (item, nil)
//				return
//			}
//			self.collectionDidSelectOutput.value = (nil, value)
//		}
//
////		didSelectInput.bind { indexPath in
////			guard let indexPath else { return }
////			guard let coinId = self.favoriteCoins[indexPath.row].coin?.coinID else {
////				self.didSelectOutput.value = (nil, self.coinInfo[indexPath.row].id)
////				return
////			}
////
////			self.didSelectOutput.value = (self.coinInfo.first(where: { $0.id == coinId }), nil)
////		}
//	}
//
//	private func startFetchingCoinInfo() {
//		callRepeatRequest()
//		timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(callRepeatRequest), userInfo: nil, repeats: true)
//	}
//
//	private func stopFetchingCoinInfo() {
//		timer?.invalidate()
//		self.isViewAppearOutput.value = (false, nil)
//	}
//
//	@objc private func callRepeatRequest() {
//		APIRequsetManager.shared.callRequest(type: [CoinInfo].self, api: .coinInfo(favoriteCoin: Array(favoriteCoins))) { result, error in
//			if let error {
//				switch error {
//				case .decodingError(let retry):
//					self.isViewAppearOutput.value = (nil, retry)
//				}
//			} else if let result {
//				self.coinInfo = result
//			}
//			self.isViewAppearOutput.value = (true, nil)
//		}
//	}
//
//	func getURL(_ url: String?) -> URL {
//		return URL(string: url ?? "https://i.namu.wiki/i/oeg0SrZ7dtO3PDuKHOHM0QAHodKoWCyGoL-YwQpfHSODs6Ld8jPC4zbss9wSuorssi3YZWzIrdoetRrV5SjBow.webp")!
//	}
//
//	private func occurEvent() {
//		for item in closures {
//			DispatchQueue.main.async {
//				item.action()
//			}
//		}
//	}
//
//	func setPriceLabel(withCoinID id: String?, kind: priceKind) -> (value: String, state: PriceState?) {
//		if let coinInfo = coinInfo.first(where: {$0.coinId == id }) {
//			return kind == .price ? NumberFormatter.setPrice(coinInfo.currentPrice, kind: kind) : NumberFormatter.setPrice(coinInfo.priceChangePercentage24H, kind: .priceChanging)
//		}
//		return ("-", nil)
//	}
//
//	func setStarImage(withCoinID id: String?) -> UIImage {
//		guard let id else { return .btnStar }
//		
//		for item in favoriteCoins where item.coin?.coinID == id {
//			return .btnStarFill
//		}
//		return .btnStar
//	}
//
//	func bind(withObject object: AnyClass, _ newClosure: @escaping ()->Void) {
//		for item in closures where item.className == object { closures = closures.filter { $0.className != object } }
//		self.closures.append((object, newClosure))
//	}
//
//	var favoriteCoinNumbersOfSction: Int {
//		return favoriteCoins.count
//	}
//
//
//
//}


//	private var isCoinInfoisAvailable: Bool {
//		return favoriteCoins.count == coinInfo.count
//	}

//	private func saveImageToDocument(image: UIImage, withId id: String) {
//		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//
//		let fileUrl = documentDirectory.appendingPathComponent("\(id).jpg")
//		guard let data = image.jpegData(compressionQuality: 0.5) else { return }
//		do {
//			try data.write(to: fileUrl)
//		} catch {
//			print(error.localizedDescription)
//		}
//	}
//
//	func loadImageToDocument(withId id: String) -> UIImage {
//		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage() }
//		let fileUrl = documentDirectory.appendingPathComponent("\(id).jpg")
//		if FileManager.default.fileExists(atPath: fileUrl.path){
//			return UIImage(contentsOfFile: fileUrl.path)!
//		}
//		return UIImage()
//	}
//
//	private func removeImageFromDocument(withId id: String) {
//		guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//		let fileUrl = documentDirectory.appendingPathComponent("\(id).jpg")
//		if FileManager.default.fileExists(atPath: fileUrl.path) {
//			do {
//				try FileManager.default.removeItem(at: fileUrl)
//			} catch {
//				print(error.localizedDescription)
//			}
//		}
//	}
