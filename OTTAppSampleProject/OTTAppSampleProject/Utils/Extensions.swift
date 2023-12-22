//
//  Extensions.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/20/23.
//

import Foundation

extension String {
    var localized: Self {
        return NSLocalizedString(self, comment: "")
    }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
