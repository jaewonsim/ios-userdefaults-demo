//
//  DataEntryViewController.swift
//  Persistence Demo
//
//  Created by Jaewon Sim on 11/24/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

protocol DataEntryDelegate {
    func didSave(with distanceInMiles: String, temperatureInFahrenheit: String)
}

class DataEntryViewController: UIViewController {

    var delegate: DataEntryDelegate?

    // MARK: - View vars
    var distanceField: UITextField!
    var temperatureField: UITextField!

    var defaults = UserDefaults.standard

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Data Entry"

        // "Cancel" bar button
        let cancelBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelBarItem

        // "Save" bar button
        let saveBarItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveBarItem

        distanceField = UITextField()
        distanceField.placeholder = "Enter distance in miles..."
        distanceField.minimumFontSize = 18
        distanceField.keyboardType = .numberPad
        distanceField.borderStyle = .roundedRect
        view.addSubview(distanceField)

        temperatureField = UITextField()
        temperatureField.placeholder = "Enter temperature in Fahrenheits..."
        temperatureField.minimumFontSize = 18
        temperatureField.keyboardType = .numberPad
        temperatureField.borderStyle = .roundedRect
        view.addSubview(temperatureField)

        setUpConstraints()
    }

    // MARK: - Constraints
    // Constraints constants
    var sideMargin: CGFloat = 40
    var interitemVerticalSpacing: CGFloat = 12

    func setUpConstraints() {
        distanceField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(interitemVerticalSpacing)
            make.centerX.equalToSuperview()
        }

        temperatureField.snp.makeConstraints { make in
            make.top.equalTo(distanceField.snp.bottom).offset(interitemVerticalSpacing)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Bar button actions
    @objc func cancel() {
        // Simply close the window when cancelled
        dismiss(animated: true)
    }

    @objc func save() {
        // Save preferences and close the window
        delegate?.didSave(with: distanceField.text ?? "0", temperatureInFahrenheit: temperatureField.text ?? "0")
        dismiss(animated: true)
    }

}
