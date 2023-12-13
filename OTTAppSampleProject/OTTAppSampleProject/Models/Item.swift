//
//  Item.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/12/23.
//

enum Item: Hashable {
    case banner(Content)
    case listWithImage(Content)
    case listWithImageAndTitle(Content)
    case listWithImageAndNumber(Content)
}
