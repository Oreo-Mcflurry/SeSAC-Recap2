//
//  CollectionViewLayout+Extension.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 3/2/24.
//

import UIKit

extension UIView {
	static func setCollectionViewLayout(_ type: CollectionViewType) -> UICollectionViewLayout {
		let layout = UICollectionViewFlowLayout()
		let padding: CGFloat = 15
		let mainWidth = UIScreen.main.bounds.width
		switch type {
		case .favorite(let isHorizontal):
			layout.itemSize = CGSize(width: (mainWidth-padding*3)/2, height: (mainWidth-padding*3)/2)
			layout.scrollDirection = isHorizontal ? .horizontal : .vertical
		case .top:
			layout.itemSize = CGSize(width: mainWidth-padding*3, height: (mainWidth-padding*3)/6)
			layout.scrollDirection = .horizontal
		}
		layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		layout.minimumLineSpacing = padding
		layout.minimumInteritemSpacing = padding
		return layout
	}
}
