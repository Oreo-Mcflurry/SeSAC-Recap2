//
//  ProfileViewController.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/27/24.
//

import UIKit

class ProfileViewController: BaseViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func configureView() {
		navigationItem.title = "Profile"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
}
