//
//  HomeViewController.swift
//  Persistence Demo
//
//  Created by Jaewon Sim on 11/25/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, DataEntryDelegate {

    // MARK: - View vars
    var distanceTitleLabel: UILabel!
    var distanceLabel: UILabel!
    var distanceEmojiLabel: UILabel!

    var temperatureTitleLabel: UILabel!
    var temperatureLabel: UILabel!
    var temperatureEmojiLabel: UILabel!

    var enterDataButton: UIButton!

    // Get UserDefaults.standard
    let defaults = UserDefaults.standard

    // These are "models" for this demo. The distance -- in miles -- that the user enters into the UITextField will be stored here. This is a Double because `Measurement` requires us to use a `Double`.
    var distanceInMiles: Double = 0.0
    
    // Similarly, the temperatures entered -- in Fahrenheit -- will be stored here.
    var temperatureInFahrenheit: Double = 0.0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Measurements"

        // Bar button item
        let settingsBarItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsBarItem

        distanceTitleLabel = UILabel()
        distanceTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        distanceTitleLabel.text = "Distance"
        view.addSubview(distanceTitleLabel)

        distanceLabel = UILabel()
        distanceLabel.text = "Distance will appear here..."
        view.addSubview(distanceLabel)

        distanceEmojiLabel = UILabel()
        distanceEmojiLabel.font = UIFont.systemFont(ofSize: 32)
        distanceEmojiLabel.text = "❓"
        view.addSubview(distanceEmojiLabel)

        temperatureTitleLabel = UILabel()
        temperatureTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        temperatureTitleLabel.text = "Temperature"
        view.addSubview(temperatureTitleLabel)

        temperatureLabel = UILabel()
        temperatureLabel.text = "Temperature will appear here..."
        temperatureLabel.textAlignment = .center
        view.addSubview(temperatureLabel)

        temperatureEmojiLabel = UILabel()
        temperatureEmojiLabel.font = UIFont.systemFont(ofSize: 32)
        temperatureEmojiLabel.text = "❓"
        view.addSubview(temperatureEmojiLabel)

        enterDataButton = UIButton()
        enterDataButton.setTitle("Tap here to enter data...", for: .normal)
        enterDataButton.backgroundColor = UIColor.init(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
        enterDataButton.layer.cornerRadius = 8
        enterDataButton.addTarget(self, action: #selector(didPressEnterData), for: .touchUpInside)
        view.addSubview(enterDataButton)

        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide or show emoji based on UserDefaults
        if defaults.bool(forKey: UserDefaultsKey.emoji.rawValue) {
            distanceEmojiLabel.isHidden = false
            temperatureEmojiLabel.isHidden = false
        } else {
            distanceEmojiLabel.isHidden = true
            temperatureEmojiLabel.isHidden = true
        }

        // Set up a MeasurementFormatter to use for formatting distances and temperatures
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .medium

        // Handle the conversion and formatting of distances
        if let distanceUnitString = defaults.string(forKey: UserDefaultsKey.distance.rawValue), let unitLength = DistanceUnit(rawValue: distanceUnitString)?.unitLength {
            let measurement = Measurement(value: distanceInMiles, unit: UnitLength.miles)
            let converted = measurement.converted(to: unitLength)
            distanceLabel.text = formatter.string(from: converted)
            distanceEmojiLabel.text = emojiForDistance(distanceInMiles)
        }

        // Handle the conversion and formatting of temperatures
        if let temperatureUnitString = defaults.string(forKey: UserDefaultsKey.temperature.rawValue), let unitTemperature = TemperatureUnit(rawValue: temperatureUnitString)?.unitTemperature {
            let measurement = Measurement(value: temperatureInFahrenheit, unit: UnitTemperature.fahrenheit)
            let converted = measurement.converted(to: unitTemperature)
            temperatureLabel.text = formatter.string(from: converted)
            temperatureEmojiLabel.text = emojiForTemperature(temperatureInFahrenheit)
        }

    }

    // MARK: - Constraints
    // Constraints constants
    var sideMargin: CGFloat = 24
    var interitemVerticalSpacingRegular: CGFloat = 12
    var interitemVerticalSpacingTall: CGFloat = 28
    var buttonHeight: CGFloat = 50

    func setUpConstraints() {
        distanceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(interitemVerticalSpacingRegular)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(sideMargin)
        }

        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceTitleLabel.snp.bottom).offset(interitemVerticalSpacingRegular)
            make.leading.trailing.equalTo(distanceTitleLabel)
        }

        distanceEmojiLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceTitleLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).inset(sideMargin)
        }

        temperatureTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(interitemVerticalSpacingTall)
            make.leading.equalTo(distanceTitleLabel)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureTitleLabel.snp.bottom).offset(interitemVerticalSpacingRegular)
            make.leading.equalTo(distanceTitleLabel)
        }

        temperatureEmojiLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureTitleLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).inset(sideMargin)
        }

        enterDataButton.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(interitemVerticalSpacingTall)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(sideMargin)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).inset(sideMargin)
            make.height.equalTo(buttonHeight)
        }
    }

    // MARK: - Actions
    @objc func openSettings() {
        // Present the next VC modally, but in a navigation controller, so that we can add buttons to the navigation bar
        let navVC = UINavigationController(rootViewController: PreferencesViewController())
        present(navVC, animated: true)
    }

    @objc func didPressEnterData() {
        let dataVC = DataEntryViewController()
        dataVC.delegate = self // Set the delegate of the data entry screen to this view controller
        let navVC = UINavigationController(rootViewController: dataVC)
        present(navVC, animated: true)
    }

    func didSave(with distanceInMiles: String, temperatureInFahrenheit: String) {
        self.distanceInMiles = Double(distanceInMiles) ?? 0.0
        self.temperatureInFahrenheit = Double(temperatureInFahrenheit) ?? 0.0
    }

    // MARK: - Utilities
    func emojiForDistance(_ distance: Double) -> String {
        switch distance {
        case 0..<1000: return "😍"
        case 1000...: return "😱"
        default: return "❓"
        }
    }

    func emojiForTemperature(_ temperature: Double) -> String {
        switch temperature {
        case ...67: return "🥶"
        case 68..<73: return "😍"
        case 74...: return "🥵"
        default: return "❓"
        }
    }
}
