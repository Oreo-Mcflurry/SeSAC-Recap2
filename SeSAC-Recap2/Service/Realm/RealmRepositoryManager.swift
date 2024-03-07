//
//  RealmRepositoryManager.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/28/24.
//

import Foundation
import RealmSwift

class RealmRepositoryManager {

	// MARK: - Realm Setting
	var realm: Realm = {
		return try! Realm()
	}()

	enum RealmError: Error {
		case isMax
	}

	// MARK: - Crate
	func createData<T: Object>(_ newData: T) throws {
		if T.isEqual(FavoriteCoinModel.self) && isFavoriteMax() { throw RealmError.isMax }
		do {
			try realm.write {
				realm.add(newData)
			}
		} catch {
			print(error)
		}
	}

	// MARK: - Read
	func fetchData<T: Object>(_ type: T.Type) -> Results<T> {
		return realm.objects(T.self)
	}
//	func fetchFavoriteCoin() -> Results<CoinModel> {
//		return realm.objects(CoinModel.self)
//	}
//
//	func fetchBuyCoin() -> Results<BuyCellCoinModel> {
//		return realm.objects(BuyCellCoinModel.self)
//	}

	// MARK: - Update
	func updateData<T: Object>(_ updateData: T) {
		do {
			try realm.write {
				realm.add(updateData, update: .modified)
			}
		} catch {
			print(error)
		}
	}

	// MARK: - Delete
//	func deleteData<T: Object>(_ type: T.Type, withCoinID id: String) {
//		do {
//			try realm.write {
//				let data = self.realm.object(ofType: T.self, forPrimaryKey: id)
//				realm.delete(data!)
//			}
//		} catch {
//			print(error)
//		}
//	}

	func deleteFavorite(withCoinID id: String) {
		do {
			try realm.write {
				if let data = realm.objects(FavoriteCoinModel.self).where( { $0.coin.coinID == id } ).first {
					realm.delete(data)
				}
			}
		} catch {
			print(error)
		}
	}

	func resetDatas() {
		do {
			try realm.write {
				realm.deleteAll()
			}
		} catch {
			print(error)
		}
	}

	// MARK: - Useage
	private func isFavoriteMax() -> Bool {
		if realm.objects(FavoriteCoinModel.self).count >= 10 {
			return true
		} else {
			return false
		}
	}

	func isSaved(withCoinID id: String) -> Bool {
		for item in realm.objects(FavoriteCoinModel.self) where item.coin?.coinID == id {
			return true
		}
		return false
	}
}
