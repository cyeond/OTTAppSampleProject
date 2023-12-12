//
//  Content.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

protocol Content: Hashable, Codable {
    var title: String { get set }
    var subtitle: String? { get set }
    var imageUrl: String { get set }
}
