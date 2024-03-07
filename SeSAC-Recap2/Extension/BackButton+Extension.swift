//
//  BackButton+Extension.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit

extension UINavigationController {
	open override func viewWillLayoutSubviews() {
		navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
}
