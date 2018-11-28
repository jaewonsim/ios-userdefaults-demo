//
//  PreferencesViewController.swift
//  Persistence Demo
//
//  Created by Jaewon Sim on 11/24/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class PreferencesViewController: UIViewController {

    // MARK: - View vars
    var distanceControl: UISegmentedControl!
    var temperatureControl: UISegmentedControl!
    var emojiControl: UISegmentedControl!

    var defaults = UserDefaults.standard

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Preferences"

        // "Cancel" bar button
        let cancelBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelBarItem

        // "Save" bar button
        let saveBarItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePreferences))
        navigationItem.rightBarButtonItem = saveBarItem

        // Create a UISegmentedControl for setting distance unit preferences
        distanceControl = UISegmentedControl()
        distanceControl.insertSegment(withTitle: "Miles", at: DistanceUnit.miles.index, animated: true)
        distanceControl.insertSegment(withTitle: "Kilometers", at: DistanceUnit.kilometers.index, animated: true)
        view.addSubview(distanceControl)

        // The UISegmentedControl for temperature unit preferences is already completed for you
        temperatureControl = UISegmentedControl()
        temperatureControl.insertSegment(withTitle: "Fahrenheit", at: TemperatureUnit.fahrenheit.index, animated: true)
        temperatureControl.insertSegment(withTitle: "Celsius", at: TemperatureUnit.celsius.index, animated: true)
        view.addSubview(temperatureControl)

        // Create a UISegmentedControl for setting emoji visibility preferences
        emojiControl = UISegmentedControl()
        emojiControl.insertSegment(withTitle: "Hide emoji", at: 0, animated: true)
        emojiControl.insertSegment(withTitle: "Show emoji", at: 1, animated: true)
        view.addSubview(emojiControl)

        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set the UISegmentedControl for distance to the current preferences pulled from UserDefaults
        if let distanceUnitString = defaults.string(forKey: UserDefaultsKey.distance.rawValue), let unit = DistanceUnit(rawValue: distanceUnitString) {
            distanceControl.selectedSegmentIndex = unit.index
        }

        // Set the UISegmentedControl for temperature to the current preferences pulled from UserDefaults
        if let temperatureUnitString = defaults.string(forKey: UserDefaultsKey.temperature.rawValue), let unit = TemperatureUnit(rawValue: temperatureUnitString) {
            temperatureControl.selectedSegmentIndex = unit.index
        }

        // Set the UISegmentedControl for emoji visibility to the current preferences pulled from UserDefaults
        let emoji = defaults.bool(forKey: UserDefaultsKey.emoji.rawValue)
        if emoji {
            emojiControl.selectedSegmentIndex = 1
        } else {
            emojiControl.selectedSegmentIndex = 0
        }

    }

    // MARK: - Constraints
    // Constraints constants
    var sideMargin: CGFloat = 40
    var interitemVerticalSpacing: CGFloat = 18

    func setUpConstraints() {
        distanceControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(interitemVerticalSpacing)
            make.centerX.equalToSuperview()
        }

        temperatureControl.snp.makeConstraints { make in
            make.top.equalTo(distanceControl.snp.bottom).offset(interitemVerticalSpacing)
            make.centerX.equalToSuperview()
        }

        emojiControl.snp.makeConstraints { make in
            make.top.equalTo(temperatureControl.snp.bottom).offset(interitemVerticalSpacing)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Bar button actions
    @objc func cancel() {
        // Simply close the window when cancelled
        dismiss(animated: true)
    }

    @objc func savePreferences() {

        // Since the enum `DistanceUnit` is a `CaseIterable`, we can use the `allCases` property to obtain an array with all of the cases listed in the order of case declaration. Then, we can access
        let selectedDistanceUnit = DistanceUnit.allCases[distanceControl.selectedSegmentIndex]
        defaults.set(selectedDistanceUnit.rawValue, forKey: UserDefaultsKey.distance.rawValue)

        let selectedTemperatureUnit = TemperatureUnit.allCases[temperatureControl.selectedSegmentIndex]
        defaults.set(selectedTemperatureUnit.rawValue, forKey: UserDefaultsKey.temperature.rawValue)

        // Here, no `enum` conversion is necessary because the UserDefaults entry for emoji visibility is a bool -- which can be natively handled. Hence, a simple true/false if/else is already safe.
        if emojiControl.selectedSegmentIndex == 1 {
            defaults.set(true, forKey: UserDefaultsKey.emoji.rawValue)
        } else {
            defaults.set(false, forKey: UserDefaultsKey.emoji.rawValue)
        }

        dismiss(animated: true)
    }

}
