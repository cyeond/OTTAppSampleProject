//
//  Storage.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/22/23.
//

import Foundation

struct Storage {
    static var searchHistory: [String] {
        get {
            return UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "searchHistory")
        }
    }
    
    static func insertToArray<T>(key: String, value: T) where T: Equatable {
        guard var array = UserDefaults.standard.array(forKey: key) as? [T] else { return }
        array.insert(value, at: 0)
        UserDefaults.standard.setValue(array.unique, forKey: key)
    }
}
