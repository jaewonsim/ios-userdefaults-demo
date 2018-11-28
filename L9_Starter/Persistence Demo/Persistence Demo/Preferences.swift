//
//  Preferences.swift
//  Persistence Demo
//
//  Created by Jaewon Sim on 11/25/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO
/// `Enum` for representing the key for `UserDefaults`; also convertible into a `String`
enum UserDefaultsKey: String {
    case distance
    case temperature
    case emoji
}

// TODO
/// `Enum` for representing units for distances (i.e. miles & kilometers)
enum DistanceUnit: String, CaseIterable {
    case miles
    case kilometers
    
    var index: Int {
        switch self {
        case .miles: return 0
        case .kilometers: return 1
        }
    }
    
    var unitLength: UnitLength {
        switch self {
        case .miles: return UnitLength.miles
        case .kilometers: return UnitLength.kilometers
        }
    }
}

// TODO
/// `Enum` for representing units for temperatures (i.e. fahrenheit & celsius)
enum TemperatureUnit: String, CaseIterable {
    case fahrenheit
    case celsius
    
    var index: Int {
        switch self {
        case .fahrenheit: return 0
        case .celsius: return 1
        }
    }
    
    var unitTemperature: UnitTemperature {
        switch self {
        case .celsius: return UnitTemperature.celsius
        case .fahrenheit: return UnitTemperature.fahrenheit
        }
    }
}
