//
//  DetailView.swift
//  SeSAC-Recap2
//
//  Created by A_Mcflurry on 2/29/24.
//

import UIKit
import DGCharts
import SnapKit

class DetailView: BaseUIView {
	let scrollView = UIScrollView()
	let chartView = LineChartView()
	let coinImage = UIImageView()
	let coinName = UILabel()
	let priceLabel = UILabel()
	let priceChangingLabel = UILabel()
	private let todayLabel = UILabel()

	let highLabelView = PriceAndDescriptionView()
	let lowLabelView = PriceAndDescriptionView()
	let allHighView = PriceAndDescriptionView()
	let allLowView = PriceAndDescriptionView()

	override func configureHierarchy() {
		self.addSubview(scrollView)
		[coinImage, coinName, priceLabel, priceChangingLabel, todayLabel].forEach { scrollView.addSubview($0) }
		[highLabelView, lowLabelView, allHighView, allLowView].forEach { scrollView.addSubview($0) }
		scrollView.addSubview(chartView)
	}

	override func configureLayout() {
		scrollView.snp.makeConstraints {
			$0.edges.equalTo(self.safeAreaLayoutGuide)
		}

		coinName.snp.makeConstraints {
			$0.trailing.greaterThanOrEqualTo(scrollView.safeAreaLayoutGuide).inset(20)
			$0.top.equalTo(scrollView.safeAreaLayoutGuide).offset(10)
		}

		coinImage.snp.makeConstraints {
//			$0.top.equalTo(self.safeAreaLayoutGuide)
			$0.centerY.equalTo(coinName)
			$0.leading.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
			$0.trailing.equalTo(coinName.snp.leading).offset(-5)
			$0.size.equalTo(50)
		}

		priceLabel.snp.makeConstraints {
			$0.top.equalTo(coinName.snp.bottom).offset(15)
			$0.leading.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
		}

		priceChangingLabel.snp.makeConstraints {
			$0.top.equalTo(priceLabel.snp.bottom).offset(5)
			$0.leading.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
		}

		todayLabel.snp.makeConstraints {
			$0.top.equalTo(priceChangingLabel)
			$0.leading.equalTo(priceChangingLabel.snp.trailing).offset(10)
		}

		let width = (UIScreen.main.bounds.width-20*3)/2

		highLabelView.snp.makeConstraints {
			$0.top.equalTo(priceChangingLabel.snp.bottom).offset(25)
			$0.leading.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
			$0.width.equalTo(width)
		}

		lowLabelView.snp.makeConstraints {
			$0.top.equalTo(highLabelView)
			$0.leading.equalTo(highLabelView.snp.trailing).offset(20)
			$0.trailing.greaterThanOrEqualTo(scrollView.safeAreaLayoutGuide).inset(20)
			$0.width.equalTo(width)
		}

		allHighView.snp.makeConstraints {
			$0.top.equalTo(highLabelView.snp.bottom).offset(20)
			$0.horizontalEdges.width.equalTo(highLabelView)
		}

		allLowView.snp.makeConstraints {
			$0.top.equalTo(allHighView)
			$0.horizontalEdges.width.equalTo(lowLabelView)
		}

		chartView.snp.makeConstraints {
			$0.horizontalEdges.bottom.equalTo(scrollView.safeAreaLayoutGuide)
			$0.top.equalTo(allLowView.snp.bottom)
		}
	}

	override func configureView() {
		coinName.font = .boldSystemFont(ofSize: 30)
		priceLabel.font = .boldSystemFont(ofSize: 40)
		todayLabel.text = "Today"
		todayLabel.textColor = .colorGray

		highLabelView.descriptionLabel.text = "고가"
		highLabelView.descriptionLabel.textColor = .colorRed
		highLabelView.priceLabel.textColor = .colorDarkGray

		allHighView.descriptionLabel.text = "신고점"
		allHighView.descriptionLabel.textColor = .colorRed
		allHighView.priceLabel.textColor = .colorDarkGray

		lowLabelView.descriptionLabel.text = "저가"
		lowLabelView.descriptionLabel.textColor = .colorBlue
		lowLabelView.priceLabel.textColor = .colorDarkGray

		allLowView.descriptionLabel.text = "신저점"
		allLowView.descriptionLabel.textColor = .colorBlue
		allLowView.priceLabel.textColor = .colorDarkGray

		priceChangingLabel.font = .systemFont(ofSize: 20)
		todayLabel.font = .systemFont(ofSize: 20)

		coinName.text = "-"
		coinImage.image = .defaultCoin
		priceLabel.text = "-"
		priceChangingLabel.text = "-"
		allHighView.priceLabel.text = "-"
		highLabelView.priceLabel.text = "-"
		allLowView.priceLabel.text = "-"
		lowLabelView.priceLabel.text = "-"
	}

	func setUpChart(_ entry: [ChartDataEntry]) {
		let set = LineChartDataSet(entries: entry)
		chartView.data = LineChartData(dataSets: [set])

		let gradientColors = [UIColor.white.cgColor,
									 UIColor.accent.cgColor]
		let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

		set.fillAlpha = 1
		set.fill = LinearGradientFill(gradient: gradient, angle: 90)
		set.drawFilledEnabled = true
		set.mode = .cubicBezier
//		set.setColor(.clear)
		set.drawCirclesEnabled = false
		set.drawValuesEnabled = false
		set.drawIconsEnabled = false

		let data = LineChartData(dataSet: set)

		chartView.data = data
	}
}
